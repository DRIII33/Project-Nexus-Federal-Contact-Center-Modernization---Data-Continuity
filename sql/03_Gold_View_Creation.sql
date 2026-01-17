/* Project Nexus: 03_Gold_View_Creation.sql
   Author: Daniel Rodriguez III
   Purpose: Deploys the 'v_modernization_gold' view to the warehouse.
   Dependency: Requires 'raw_ingestion' table and validated logic from script 02.
*/

CREATE OR REPLACE VIEW `driiiportfolio.contact_center.v_modernization_gold` AS
SELECT 
    call_id,
    source_system,
    
    -- Standardization: Handling multiple date formats from legacy vs modern
    CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END AS clean_timestamp,
    
    wait_time_sec,
    
    -- Pre-calculating KPI: Service Level Agreement (SLA) Met (Target < 120s)
    IF(wait_time_sec <= 120, 1, 0) AS is_sla_met,
    
    -- Handling Nulls from Legacy Systems
    COALESCE(resolution_status, 'Unknown/Legacy') AS clean_resolution_status,
    
    caller_intent,
    
    -- Time-based Buckets for Trending (Reduces Looker processing)
    EXTRACT(DATE FROM (CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END)) AS call_date

FROM 
    `driiiportfolio.contact_center.raw_ingestion`;
