/* Project Nexus: 02_DML_Data_Transformation.sql
   Author: Daniel Rodriguez III
   Purpose: Transformation logic to normalize Legacy vs. Cloud data.
   Usage: Run this query to validate data quality rules before updating the Gold View.
*/

SELECT 
    call_id,
    source_system,
    
    -- TRANSFORMATION 1: Date Standardization
    -- Logic: Cloud system uses ISO 8601, Legacy uses US format (MM/DD/YYYY)
    CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END AS clean_timestamp,

    wait_time_sec,

    -- TRANSFORMATION 2: SLA KPI Calculation
    -- Logic: Determine if call was answered within 120 seconds (1 = Met, 0 = Missed)
    IF(wait_time_sec <= 120, 1, 0) AS is_sla_met,

    -- TRANSFORMATION 3: Null Handling
    -- Logic: Legacy systems often drop resolution status; tag as 'Unknown' for audit
    COALESCE(resolution_status, 'Unknown/Legacy') AS clean_resolution_status,

    caller_intent,

    -- TRANSFORMATION 4: Derived Reporting Date
    -- Logic: Extract date component for daily trending to optimize Looker performance
    EXTRACT(DATE FROM (CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END)) AS call_date

FROM 
    `driiiportfolio.contact_center.raw_ingestion`
