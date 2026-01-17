# Project Nexus: Federal Contact Center Modernization & Data Continuity

### **Bridging Legacy Systems to Cloud-Based Operations for Mission-Critical Health Agencies**

**Author:** Daniel Rodriguez III
**Date:** January 16, 2026
**Project ID:** `driiiportfolio`
**Status:** Active / Portfolio Demonstration

---

## **1. Executive Summary**

**Project Nexus** is a data modernization simulation designed to mirror the current challenges facing large U.S. health agencies: migrating 24/7 contact centers from disparate legacy systems to a unified cloud environment.

This project demonstrates the **Data Scientist/Analyst** capabilities required to solve "Data Continuity" issues—ensuring that as technology updates, leadership retains visibility into key performance indicators (KPIs) like *First Call Resolution (FCR)* and *Average Speed to Answer (ASA)*. It specifically addresses the "Position of Trust" requirement for handling sensitive federal data with zero-defect accuracy.

---

## **2. Business Scenario & Problem Statement**

* **The Context:** A federal health agency is transitioning from 30-year-old on-premise telephony (Legacy Oracle, Avaya) to a modern Cloud Contact Center (CBCC) to improve "24/7 virtual access to high-quality care".
* **The Problem:** The migration has created a "data blackout." Legacy data formats (MM/DD/YYYY) do not match modern ISO standards, and null values are crashing automated reports. Leadership is currently unable to verify if the modernization is actually improving Veteran/Patient access.
* **The Solution:** A robust **SQL-based "Gold View"** layer that standardizes data across all eras, paired with a **Python Automated Validation Pipeline** that serves as a quality gatekeeper before data reaches executive dashboards.

---

## **3. Technical Architecture & Strategy**

This project utilizes a **Modern Data Stack (MDS)** approach suitable for federal environments:

* **Ingestion (Python):** Generates realistic synthetic data representing "messy" federal legacy systems (inconsistent timestamps, dropouts).
* **Warehousing (Google BigQuery):** Utilizes a "ELT" (Extract, Load, Transform) strategy.
* *Raw Layer:* Ingests data "as-is" to preserve audit trails.
* *Gold Layer (View):* Performs heavy transformation in SQL to reduce processing load on visualization tools (Optimizing for speed).


* **Quality Assurance (Python):** Runs automated "Health Checks" on the Gold Layer to detect anomalies (Negative wait times, drift) before reporting.
* **Visualization (Looker Studio):** Delivers "No-Code" dashboards for stakeholders, powered by the pre-calculated SQL views.

---

## **4. Repository Structure**

```text
├── data/
│   └── federal_contact_center_data.csv    # Synthetic dataset (5,000+ records) simulating Legacy vs. Cloud streams
├── sql/
│   ├── 01_DDL_Table_Creation.sql          # BigQuery Schema definition for 'driiiportfolio'
│   ├── 02_DML_Data_Transformation.sql     # Logic for standardizing legacy date formats
│   └── 03_Gold_View_Creation.sql          # The "Bridge" View: Pre-calculating SLAs to eliminate Looker calculated fields
├── notebooks/
│   └── 01_Synthetic_Data_Gen.ipynb        # Python script for generating the test data
├── scripts/
│   └── data_validation_checks.py          # Automated QA script (Null checks, Logic checks, RCA logs)
├── documentation/
│   └── (Pending Processing)               # Data Dictionaries and Process Flow Diagrams
└── README.md                              # Project Overview

```

---

## **5. Key Deliverables & Skills Demonstrated**

This project specifically maps to the **Fathom Management, LLC** Job Description requirements:

| JD Requirement | Project Deliverable / Skill Demonstrated |
| --- | --- |
| **"Update and optimize business queries... to reflect new or consolidated data"** | **SQL Gold View:** `03_Gold_View_Creation.sql` merges 3 disparate systems into one schema, handling logic changes automatically. |
| **"Identify and resolve data discrepancies... ensuring integrity"** | **Python QA Script:** `data_validation_checks.py` automatically flags "Negative Wait Times" and "Invalid Dates" for Root Cause Analysis (RCA). |
| **"Design... automated reporting solutions to streamline recurring data analysis"** | **BigQuery View Strategy:** By calculating KPIs (like `is_sla_met`) in SQL, the dashboard requires zero manual manipulation, automating the reporting cycle. |
| **"Comfortable with ambiguity... independent work"** | **Synthetic Data Generation:** Created a realistic dataset from scratch to simulate the "ambiguity" of undefined legacy formats. |
| **"Position of Trust / Federal Experience"** | **Validation Standards:** The scripts apply strict "completeness" checks (Null detection) consistent with federal compliance standards. |

---

## **6. Setup & Usage**

### **Prerequisites**

* Google Cloud Platform (GCP) Account with BigQuery enabled.
* Python 3.x (or Google Colab).
* Access to Looker Studio.

### **Instructions**

1. **Generate Data:** Run `/notebooks/01_Synthetic_Data_Gen.ipynb` to create the raw CSV.
2. **Load to Warehouse:** Upload CSV to BigQuery project `driiiportfolio` using schema in `/sql/01_DDL_Table_Creation.sql`.
3. **Build the Bridge:** Execute `/sql/03_Gold_View_Creation.sql` to create the standardized view.
4. **Validate Quality:** Run `/scripts/data_validation_checks.py`. *Note: Proceed to dashboarding only if this script returns "Pass".*
5. **Visualize:** Connect Looker Studio to `v_modernization_gold`.

---

## **7. Contact**

**Daniel Rodriguez III**

* **Role:** Data Scientist / Analyst
* **Specialty:** Operational Analytics, Federal Data Compliance, & Modernization
* **Location:** Hewitt, TX
* **LinkedIn:** [Daniel Rodriguez II LinkedIn Profile] (https://www.linkedin.com/in/daniel-rodriguez-iii-1471322a7/)
* **Email:** DRIIIGistus@gmail.com
