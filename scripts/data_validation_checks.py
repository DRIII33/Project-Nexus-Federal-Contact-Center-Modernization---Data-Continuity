# This script is optimized for Google Colab and uses 'pandas-gbq' to interface with the BigQuery project 'driiiportfolio'.


import pandas as pd
from google.cloud import bigquery
from google.colab import auth

# 1. Authentication & Configuration
auth.authenticate_user()
PROJECT_ID = 'driiiportfolio'
DATASET_ID = 'contact_center'
TABLE_ID = 'raw_ingestion'

client = bigquery.Client(project=PROJECT_ID)

def run_modernization_validation():
    """
    Performs critical data quality audits to support 
    the Contact Center Modernization initiative.
    """
    
    # Load data from BigQuery view created in the previous phase
    query = f"SELECT * FROM `{PROJECT_ID}.{DATASET_ID}.v_modernization_gold`"
    df = pd.read_gbq(query, project_id=PROJECT_ID)
    
    print(f"--- Data Quality Audit Report: Project Nexus ---")
    print(f"Total Records Analyzed: {len(df)}\n")

    # --- TEST 1: Completeness (Null Check) ---
    # Addresses JD requirement: "Checking data for accuracy and completeness"
    null_report = df.isnull().sum()
    print("1. Completeness Check (Missing Values):")
    print(null_report[null_report > 0] if null_report.any() else "Status: Pass (No missing values)")
    print("-" * 30)

    # --- TEST 2: Standardization (Modernization Logic) ---
    # Addresses JD: "Ensure data warehouse... accurately incorporate changes"
    # Logic: Flag any records that failed the SQL timestamp parsing
    invalid_dates = df[df['clean_timestamp'].isnull()]
    print(f"2. Format Standardization Check:")
    print(f"Records with Invalid/Legacy Date Formats: {len(invalid_dates)}")
    if len(invalid_dates) > 0:
        print(f"Action: Flag for manual reconciliation.")
    print("-" * 30)

    # --- TEST 3: Accuracy (Wait Time Logic) ---
    # Addresses Resume Skill: "Anomaly detection and KPI monitoring"
    # Logic: Federal SLAs shouldn't have negative wait times or extreme outliers
    logic_errors = df[df['wait_time_sec'] < 0]
    outliers = df[df['wait_time_sec'] > 3600] # Calls over 1 hour
    print(f"3. Logical Integrity Check:")
    print(f"Negative Wait Times Found: {len(logic_errors)}")
    print(f"Extreme Outliers (>1hr wait): {len(outliers)}")
    print("-" * 30)

    # --- TEST 4: Integrity (System Source Distribution) ---
    # Addresses Resume Skill: "Data reconciliation and metadata audits"
    print("4. Source System Reconciliation:")
    print(df['source_system'].value_counts(normalize=True).map(lambda n: '{:.2%}'.format(n)))
    
    # Exporting flags for Root Cause Analysis (RCA) 
    # Directly maps to your Resume experience reducing errors by 90%
    if len(invalid_dates) > 0 or len(logic_errors) > 0:
        error_log = pd.concat([invalid_dates, logic_errors])
        error_log.to_csv('modernization_error_log.csv', index=False)
        print("\n[ALERT] Error log generated for stakeholder review.")

if __name__ == "__main__":
    run_modernization_validation()
