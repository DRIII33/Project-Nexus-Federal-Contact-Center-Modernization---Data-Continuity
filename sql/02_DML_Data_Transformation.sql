/* Project Nexus: 02_DML_Data_Transformation.sql
   Author: Daniel Rodriguez III
   Purpose: Transformation logic to normalize Legacy vs. Cloud data.
   Usage: Run this query to validate data quality rules before updating the Gold View.
*/

/* Project Nexus: 02_DML_Data_Transformation.sql */
SELECT 
    call_id,
    source_system,
    caller_region, -- NEW: Passed through for regional analysis
    CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END AS clean_timestamp,
    wait_time_sec,
    IF(wait_time_sec <= 120, 1, 0) AS is_sla_met,
    COALESCE(resolution_status, 'Unknown/Legacy') AS clean_resolution_status,
    caller_intent,
    EXTRACT(DATE FROM (CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END)) AS call_date
FROM 
    `driiiportfolio.contact_center.raw_ingestion`;
