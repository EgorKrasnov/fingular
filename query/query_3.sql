WITH last_events AS (
    SELECT
        sessions_log.session_id,
        sessions_log.user_id,
        sessions_log.event_id,
        sessions_log.time_stamp,
        ROW_NUMBER() OVER (
            PARTITION BY sessions_log.user_id, sessions_log.session_id
            ORDER BY sessions_log.time_stamp DESC
        ) AS rn
    FROM sessions_log
    WHERE sessions_log.time_stamp >= '2023-05-01'
),

ranked AS (
    SELECT
        DATE_TRUNC('week', last_events.time_stamp) AS week_start,
        dim_events.event_name,
        COUNT(*) AS event_count,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_TRUNC('week', last_events.time_stamp)
            ORDER BY COUNT(*) DESC
        ) AS rank_in_week
    FROM last_events
    JOIN dim_events
        ON last_events.event_id = dim_events.id
    WHERE last_events.rn = 1
    GROUP BY
        DATE_TRUNC('week', last_events.time_stamp),
        dim_events.event_name
    HAVING
        COUNT(*) > 0
)

SELECT
    ranked.week_start,
    ranked.event_name,
    ranked.event_count,
    ranked.rank_in_week
FROM ranked
WHERE ranked.rank_in_week <= 10
ORDER BY
    ranked.week_start,
    ranked.rank_in_week;