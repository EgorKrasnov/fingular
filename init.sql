CREATE TABLE dim_campaigns (
    id INT PRIMARY KEY,
    campaign_name TEXT,
    started_ts TIMESTAMP,
    ended_ts TIMESTAMP,
    channel_id INT
);

CREATE TABLE dim_channels (
    id INT PRIMARY KEY,
    name TEXT,
    row_actual_from_ts TIMESTAMP,
    row_actual_to TIMESTAMP
);

CREATE TABLE dim_templates (
    id INT PRIMARY KEY,
    channel_id INT,
    template_text TEXT,
    row_actual_from_ts TIMESTAMP,
    row_actual_to TIMESTAMP
);

CREATE TABLE campaign_communications (
    id INT PRIMARY KEY,
    communication_id BIGINT,
    campaign_id INT,
    status_ts TIMESTAMP,
    user_id BIGINT,
    communication_status_id INT
);

CREATE TABLE dim_communication_statuses (
    id INT PRIMARY KEY,
    status_name TEXT,
    row_actual_from TIMESTAMP,
    row_actual_to TIMESTAMP
);

CREATE TABLE events (
    user_id INT,
    event_type TEXT,
    event_time TIMESTAMP
);

CREATE TABLE sessions_log (
    id BIGINT,
    session_id BIGINT,
    user_id BIGINT,
    event_id BIGINT,
    time_stamp TIMESTAMP
);

CREATE TABLE dim_events (
    id BIGINT PRIMARY KEY,
    event_name TEXT,
    row_actual_from TIMESTAMP,
    row_actual_to TIMESTAMP
);

CREATE TABLE transaction_f (
    id BIGINT,
    created_ts TIMESTAMP,
    client_key BIGINT,
    amount NUMERIC,
    application_id INT
);

CREATE TABLE dim_application (
    id BIGINT,
    application_id INT,
    application_name TEXT,
    row_actual_from TIMESTAMP,
    row_actual_to TIMESTAMP
);

CREATE TABLE fact_events (
    id BIGINT,
    event_ts TIMESTAMP,
    user_id TEXT,
    business_domain TEXT,
    client_id TEXT,
    event_name TEXT
);

