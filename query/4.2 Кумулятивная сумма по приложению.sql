WITH dates AS (
    SELECT
        generate_series(
            DATE '2023-05-01',
            DATE '2023-05-31',
            INTERVAL '1 day'
        )::date AS dt
),

apps AS (
    SELECT DISTINCT
        dim_application.application_id,
        dim_application.application_name
    FROM dim_application
),

calendar AS (
    SELECT
        apps.application_id,
        apps.application_name,
        dates.dt
    FROM apps
    CROSS JOIN dates
),

daily AS (
    SELECT
        transaction_f.application_id,
        DATE(transaction_f.created_ts) AS dt,
        SUM(transaction_f.amount) AS daily_amount
    FROM transaction_f
    WHERE transaction_f.created_ts BETWEEN '2023-05-01' AND '2023-05-31'
    GROUP BY
        transaction_f.application_id,
        DATE(transaction_f.created_ts)
)

SELECT
    calendar.application_name,
    calendar.dt,
    SUM(COALESCE(daily.daily_amount, 0)) OVER (
        PARTITION BY calendar.application_name
        ORDER BY calendar.dt
    ) AS cumulative_sum
FROM calendar
LEFT JOIN daily
    ON calendar.application_id = daily.application_id
   AND calendar.dt = daily.dt
ORDER BY
    calendar.application_name,
    calendar.dt;