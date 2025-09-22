WITH campaigns_q AS (
    SELECT
        id,
        campaign_name,
        started_ts,
        channel_id
    FROM dim_campaigns
    WHERE started_ts BETWEEN '2023-07-01' AND '2023-12-31'
),

channels_q AS (
    SELECT
        id,
        name
    FROM dim_channels
    WHERE name = 'PUSH'
),

statuses_q AS (
    SELECT
        id,
        status_name
    FROM dim_communication_statuses
),

communications_q AS (
    SELECT
        communication_id,
        campaign_id,
        communication_status_id,
        status_ts
    FROM campaign_communications
),

joined AS (
    SELECT
        DATE_TRUNC('month', communications_q.status_ts) AS month,
        channels_q.id AS channel_id,
        channels_q.name AS channel_name,
        ROUND(
            100.0 * SUM(
                CASE WHEN statuses_q.status_name = 'delivered' THEN 1 ELSE 0 END
            ) / NULLIF(COUNT(DISTINCT communications_q.communication_id), 0),
            2
        ) AS delivered_percent
    FROM campaigns_q
    JOIN channels_q
        ON campaigns_q.channel_id = channels_q.id
    LEFT JOIN communications_q
        ON communications_q.campaign_id = campaigns_q.id
    LEFT JOIN statuses_q
        ON communications_q.communication_status_id = statuses_q.id
    GROUP BY
        DATE_TRUNC('month', communications_q.status_ts),
        channels_q.id,
        channels_q.name
)

SELECT
    joined.month,
    joined.channel_id,
    joined.channel_name,
    joined.delivered_percent
FROM joined
ORDER BY
    joined.channel_id,
    joined.month;