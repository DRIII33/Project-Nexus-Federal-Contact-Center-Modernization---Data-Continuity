#This script generates data that replicates common modernization "pain points": inconsistent date formats, null values in legacy systems, and mismatched categorical labels.

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

def generate_federal_contact_data(records=5000):
    np.random.seed(42)
    
    # Define systems (Modernization context)
    systems = ['Legacy_Oracle', 'Legacy_Avaya', 'Cloud_Modern_Connect']
    # NEW: Define federal regions for Geographic Access analysis
    regions = ['Northeast', 'Southeast', 'Midwest', 'Southwest', 'West']
    
    data = []
    for i in range(records):
        system = np.random.choice(systems, p=[0.25, 0.25, 0.50])
        timestamp = datetime(2025, 1, 1) + timedelta(minutes=np.random.randint(0, 525600))
        
        # Simulate legacy data messiness (Inconsistent formats)
        call_id = f"CALL-{i:06d}"
        wait_time = np.random.gamma(shape=2, scale=60) if system == 'Cloud_Modern_Connect' else np.random.uniform(100, 600)
        
        # Simulate data dropouts in legacy systems (Nulls)
        resolution = np.random.choice(['Resolved', 'Escalated', 'Dropped', None], p=[0.7, 0.15, 0.1, 0.05])
        
        data.append({
            'call_id': call_id,
            'source_system': system,
            'call_timestamp': timestamp.isoformat() if system == 'Cloud_Modern_Connect' else timestamp.strftime('%m/%d/%Y %H:%M:%S'),
            'wait_time_sec': round(wait_time, 2),
            'resolution_status': resolution,
            'agent_id': f"AGT-{np.random.randint(100, 999)}",
            'caller_intent': np.random.choice(['Benefits', 'Pharmacy', 'Mental Health', 'General Inquiry']),
            'caller_region': np.random.choice(regions) # NEW: Geographic dimension
        })

    df = pd.DataFrame(data)
    
    # Save for BigQuery Upload
    df.to_csv('federal_contact_center_data.csv', index=False)
    print("Successfully generated 'federal_contact_center_data.csv' with caller_region for driiiportfolio.")

generate_federal_contact_data()
