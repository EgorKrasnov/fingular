WITH user_flags AS (
    SELECT
        fact_events.user_id,
        MAX(CASE WHEN fact_events.client_id = 'mobile' THEN 1 ELSE 0 END) AS has_mobile,
        MAX(CASE WHEN fact_events.client_id = 'desktop' THEN 1 ELSE 0 END) AS has_desktop
    FROM fact_events
    GROUP BY
        fact_events.user_id
),

desktop_only_users AS (
    SELECT
        user_flags.user_id
    FROM user_flags
    WHERE user_flags.has_desktop = 1
      AND user_flags.has_mobile = 0
),

user_domains AS (
    SELECT DISTINCT
        fact_events.user_id,
        fact_events.business_domain
    FROM fact_events
    JOIN desktop_only_users
        ON fact_events.user_id = desktop_only_users.user_id
)

SELECT
    user_domains.business_domain,
    COUNT(user_domains.user_id) AS desktop_only_users
FROM user_domains
GROUP BY
    user_domains.business_domain
ORDER BY
    desktop_only_users DESC
LIMIT 1;