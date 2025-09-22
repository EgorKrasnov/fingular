WITH events_sorted AS (
    SELECT
        user_id,
        event_time,
        LAG(event_time) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS prev_time
    FROM events
),

sessions AS (
    SELECT
        user_id,
        event_time,
        CASE
            WHEN prev_time IS NULL
                 OR event_time - prev_time > INTERVAL '30 minutes'
            THEN 1 ELSE 0
        END AS is_new_session
    FROM events_sorted
),

session_marks AS (
    SELECT
        user_id,
        event_time,
        SUM(is_new_session) OVER (
            PARTITION BY user_id
            ORDER BY event_time
        ) AS session_number
    FROM sessions
)

SELECT
    user_id,
    MD5(user_id::text || '-' || session_number::text) AS session_id,
    MIN(event_time) AS session_start_time,
    MAX(event_time) AS session_end_time,
    ROUND(
        EXTRACT(EPOCH FROM (MAX(event_time) - MIN(event_time))) / 60,
        2
    ) AS session_duration_minutes,
    COUNT(*) AS event_count
FROM session_marks
GROUP BY
    user_id,
    session_number
HAVING
    COUNT(*) > 1
ORDER BY
    user_id,
    session_start_time;