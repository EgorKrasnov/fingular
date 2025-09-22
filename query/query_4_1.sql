WITH daily AS (
    SELECT
        client_key,
        DATE(created_ts) AS dt,
        SUM(amount) AS daily_amount
    FROM transaction_f
    WHERE created_ts BETWEEN '2023-05-01' AND '2023-05-31'
    GROUP BY client_key, DATE(created_ts)
)
SELECT
    client_key,
    dt,
    SUM(daily_amount) OVER (PARTITION BY client_key ORDER BY dt) AS cumulative_sum
FROM daily
ORDER BY client_key, dt;