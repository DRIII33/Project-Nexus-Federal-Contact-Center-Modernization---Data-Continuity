
/* Project Nexus: 03_Gold_View_Creation.sql 
   Author: Daniel Rodriguez III
   Purpose: Deploys final 'v_modernization_gold' view with enhanced Geo mapping.
*/

CREATE OR REPLACE VIEW `driiiportfolio.contact_center.v_modernization_gold` AS

SELECT 
    call_id,
    source_system,
    caller_region,
    
    -- ENHANCED GEO MAPPING: Standardizing regions to U.S. State lists for Looker
    -- This allows Looker Studio to "Fill" the map for all states in a region.
    CASE 
        WHEN caller_region = 'Northeast' THEN 'CT, ME, MA, NH, RI, VT, NJ, NY, PA'
        WHEN caller_region = 'Southeast' THEN 'AL, AR, FL, GA, KY, LA, MS, NC, SC, TN, VA, WV'
        WHEN caller_region = 'Midwest'   THEN 'IL, IN, IA, KS, MI, MN, MO, NE, ND, OH, SD, WI'
        WHEN caller_region = 'Southwest' THEN 'AZ, NM, OK, TX'
        WHEN caller_region = 'West'      THEN 'AK, CA, CO, HI, ID, MT, NV, OR, UT, WA, WY'
        ELSE 'Unknown'
    END AS state_map_codes,

    -- Standardized Timestamps
    CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END AS clean_timestamp,
    
    wait_time_sec,
    
    -- SLA Metric (1 = Met, 0 = Missed)
    IF(wait_time_sec <= 120, 1, 0) AS is_sla_met,
    
    -- Null Handling
    COALESCE(resolution_status, 'Unknown/Legacy') AS clean_resolution_status,
    
    caller_intent,
    
    -- Date component for daily trending
    EXTRACT(DATE FROM (CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END)) AS call_date

FROM 
    `driiiportfolio.contact_center.raw_ingestion`;
