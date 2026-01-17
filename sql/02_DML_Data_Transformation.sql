SELECT 
    call_id,
    source_system,
    -- Standardization: Handling multiple date formats from legacy vs modern
    CASE 
        WHEN source_system = 'Cloud_Modern_Connect' THEN PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', call_timestamp)
        ELSE PARSE_TIMESTAMP('%m/%d/%Y %H:%M:%S', call_timestamp)
    END AS clean_timestamp,
    wait_time_sec,
FROM 
    `driiiportfolio.contact_center.raw_ingestion`;
