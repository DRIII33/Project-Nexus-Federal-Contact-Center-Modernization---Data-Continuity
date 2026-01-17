
-- DDL: Creating the landing table in BigQuery
CREATE OR REPLACE TABLE `driiiportfolio.contact_center.raw_ingestion` (
    call_id STRING,
    source_system STRING,
    call_timestamp STRING, -- Initially string to handle inconsistent formats
    wait_time_sec FLOAT64,
    resolution_status STRING,
    agent_id STRING,
    caller_intent STRING
);
