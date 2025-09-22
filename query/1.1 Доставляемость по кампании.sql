WITH channels_q AS (
    SELECT id, name
    FROM dim_channels
    WHERE name = 'PUSH'
),

campaigns_q AS (
    SELECT 
        id, 
        campaign_name, 
        started_ts, 
        channel_id
    FROM dim_campaigns
    WHERE started_ts BETWEEN '2023-07-01' AND '2023-12-31'
),

communications_q AS (
    SELECT 
        communication_id, 
        campaign_id, 
        communication_status_id
    FROM campaign_communications
),

statuses_q AS (
    SELECT 
        id, 
        status_name
    FROM dim_communication_statuses
)

SELECT
    campaigns_q.campaign_name,
    campaigns_q.started_ts::date,
    ROUND(
        SUM(CASE WHEN statuses_q.status_name = 'delivered' THEN 1 ELSE 0 END) 
        * 100.0 / 
        NULLIF(COUNT(DISTINCT communications_q.communication_id), 0),
        2
    ) AS delivered_percent
FROM campaigns_q
JOIN channels_q ON campaigns_q.channel_id = channels_q.id
LEFT JOIN communications_q ON campaigns_q.id = communications_q.campaign_id
LEFT JOIN statuses_q ON communications_q.communication_status_id = statuses_q.id
GROUP BY campaigns_q.campaign_name, campaigns_q.started_ts
ORDER BY campaigns_q.started_ts;