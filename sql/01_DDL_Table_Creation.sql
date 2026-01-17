-- DDL: Creating the landing table in BigQuery project driiiportfolio
CREATE OR REPLACE TABLE `driiiportfolio.contact_center.raw_ingestion` (
    call_id STRING,
    source_system STRING,
    call_timestamp STRING, 
    wait_time_sec FLOAT64,
    resolution_status STRING,
    agent_id STRING,
    caller_intent STRING,
    caller_region STRING -- NEW: Added to capture regional data
);
