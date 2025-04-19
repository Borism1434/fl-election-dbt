##  Florida Voter ETL & Analysis

## 1. Project Overview
This project manages the end-to-end pipeline for transforming raw Florida voter file snapshots—originally distributed by county in .txt format on physical discs by the Supervisor of Elections—into a centralized, structured PostgreSQL database hosted on a home server. Using Python for ingestion and cleaning, and dbt for modeling, it standardizes millions of voter records from 2016 to 2024 into analysis-ready formats.

At its core, this project is a political data initiative rooted in transparency and technical rigor. The goal is to uncover meaningful trends in voter behavior—such as party switching, demographic shifts, and geographic mobility—by building reproducible pipelines and accessible reporting models.

Future iterations will incorporate even more election data to explore how Florida’s electorate has evolved over time. Each step emphasizes the use of best-in-class data engineering practices and open-source tools to produce work that is both rigorous and replicable.

Ultimately, the aspiration is to empower organizers, analysts, and advocates with data-driven insights into Florida’s political landscape—using technology to help us better understand the people behind the numbers.

## 2. Data Sources
- Florida's Division of Elections: 
    - Voterfile Extracts 
- OpenStreetMap (OSM) extracts provided by [Geofabrik](https://download.geofabrik.de/).
    - Geocoded address data is sourced from a self-hosted [Nominatim](https://nominatim.org/) server using Florida-specific 
- Planned Future Sources: 
    - Florida Campaign Finance datasets to explore correlations between campaign spending and voter behavior over time.

## 3. Technical Stack
- Data Engineering & Processing
    - dbt: 
        - Manages SQL-based data transformations with modular, version-controlled models.
    - python: 
        - Used for retrieving external data sources (e.g., voter files, geodata), cleaning raw data, and building ETL pipelines.
        - Threading -- Enables parallel geocoding to reduce processing time across large datasets.
    - Docker: 
        – Used to containerize tools like Nominatim for consistent local deployments.
- Storage & Databases
    - PostgreSQL - Main warehouse storing structured and cleaned voter data.
    - PostGIS – Adds spatial querying and geographic indexing to the PostgreSQL database.
    - SQLite – Lightweight, file-based cache to store previously geocoded addresses and minimize repeated queries.

## 4. Project Structure

- `ETL/` – Python scripts to process and load raw voter files into the database  
- `models/` – dbt models for transforming data  
  - `intermediate/` – early-stage transformations  
  - `reporting/` – final analysis-ready outputs  
- `macros/` – reusable SQL snippets (Jinja macros) for dbt  
- `seeds/` – reference datasets like party codes or static tables  
- `snapshots/` – (optional) tracking historical changes over time  
- `sql scripts/qa_checks/` – standalone SQL for QA & validation  
- `tests/` – dbt model tests (e.g., for nulls, uniqueness)

Other files and folders:

- `.vscode/` – VS Code project settings (optional)  
- `.gitignore` – tells Git which files to ignore  
- `dbt_project.yml` – main config file for the dbt project  
- `setup.sh` – bash script for initial setup and automation  
- `readme.md` – this documentation  
- `.DS_Store` – macOS system file (can be ignored)
### 5. Use Cases & Analysis Goals
This project is designed with grassroots power-building in mind — enabling community orgs, local campaigns, and volunteer-led efforts to harness the same insights as national operations, without needing a massive budget.

- **Track Local Voter Movement**  
  Monitor shifts in where voters live across counties and cities to better assign canvassers, volunteers, and resources.

- **Follow Party Switching Trends**  
  Identify where voters are leaving one party for another — a key signal for narrative shifts, persuasion zones, or reactivation.

- **Build Turnout Strategy with Actual Data**  
  Use registration and history trends across cycles to decide where to invest GOTV, postcarding, or digital pushes.

- **Geocode Voter Addresses with Free Tools**  
  Generate latitude and longitude from voter addresses using open-source tech (Nominatim + OpenStreetMap), enabling powerful maps without commercial licenses.

- **Understand Engagement by Race & Age**  
  Break down changes in voter behavior by demographics to ensure no group is left behind — and tailor outreach accordingly.

- **Precinct-Level Power Mapping**  
  Build maps to find underrepresented precincts or areas with high potential for organizing — and share that intel back to communities.

- **Reproducible, Transparent Analysis**  
  Every step is documented and versioned with GitHub, dbt, and open data sources — so you can retrace, remix, and reuse without black-box tools.

- **Shared Infrastructure for Coalitions**  
  Designed so multiple orgs can collaborate on one clean, reliable voter file — instead of each org cleaning it from scratch.

- **Future Expansion to Finance, Polling, and Texting Data**  
  The database is being built to eventually include campaign finance records, volunteer data, and more — all in one stack.

- **Data as a Community Asset**  
  The long-term goal is to make voter data infrastructure a shared resource, not a gatekept product.