 {{ config(materialized='table') }}

 
WITH voter_details AS (
    SELECT voter_id, reg_date, county, party, 2016 AS election_year 
    FROM {{ source('voter_file_source', '2016_election_detail') }}
    UNION ALL
    SELECT voter_id, reg_date, county, party, 2018 AS election_year 
    FROM {{ source('voter_file_source', '2018_election_detail') }}
    UNION ALL
    SELECT voter_id, reg_date, county, party, 2020 AS election_year 
    FROM {{ source('voter_file_source', '2020_election_detail') }}
    UNION ALL
    SELECT voter_id, reg_date, county, party, 2022 AS election_year 
    FROM {{ source('voter_file_source', '2022_election_detail') }}
    UNION ALL
    SELECT voter_id, reg_date, county, party, 2024 AS election_year 
    FROM {{ source('voter_file_source', '2024_election_detail') }}
), 

voter_history AS (
    SELECT 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') AS vote_history_code,
        2016 AS election_year
    FROM {{ source('voter_file_source', '2016_election_history') }}

    UNION ALL

    SELECT 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') AS vote_history_code,
        2018 AS election_year
    FROM {{ source('voter_file_source', '2018_election_history') }}

    UNION ALL

    SELECT 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') AS vote_history_code,
        2020 AS election_year
    FROM {{ source('voter_file_source', '2020_election_history') }}

    UNION ALL

    SELECT 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') AS vote_history_code,
        2022 AS election_year
    FROM {{ source('voter_file_source', '2022_election_history') }}

    UNION ALL

    SELECT 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') AS vote_history_code,
        2024 AS election_year
    FROM {{ source('voter_file_source', '2024_election_history') }}
),

voter_continuity AS (
    SELECT 
        vd.voter_id,

        -- Get the earliest registration date
        MIN(reg_date) AS reg_date,

        -- Get the first and last year a voter appears
        MIN(vh.election_year) AS first_year,
        MAX(vh.election_year) AS last_year,

        -- Aggregate party and county information per voter
        MAX(CASE WHEN vh.election_year = 2016 THEN party END) AS party_2016,
        MAX(CASE WHEN vh.election_year = 2018 THEN party END) AS party_2018,
        MAX(CASE WHEN vh.election_year = 2020 THEN party END) AS party_2020,
        MAX(CASE WHEN vh.election_year = 2022 THEN party END) AS party_2022,
        MAX(CASE WHEN vh.election_year = 2024 THEN party END) AS party_2024,

        MAX(CASE WHEN vh.election_year = 2016 THEN county END) AS county_2016,
        MAX(CASE WHEN vh.election_year = 2018 THEN county END) AS county_2018,
        MAX(CASE WHEN vh.election_year = 2020 THEN county END) AS county_2020,
        MAX(CASE WHEN vh.election_year = 2022 THEN county END) AS county_2022,
        MAX(CASE WHEN vh.election_year = 2024 THEN county END) AS county_2024,
        -- Aggregate vote method per election year
        MAX(CASE WHEN vh.election_year = 2016 THEN vh.vote_history_code END) AS vote_history_code_2016,
        MAX(CASE WHEN vh.election_year = 2018 THEN vh.vote_history_code END) AS vote_history_code_2018,
        MAX(CASE WHEN vh.election_year = 2020 THEN vh.vote_history_code END) AS vote_history_code_2020,
        MAX(CASE WHEN vh.election_year = 2022 THEN vh.vote_history_code END) AS vote_history_code_2022,
        MAX(CASE WHEN vh.election_year = 2024 THEN vh.vote_history_code END) AS vote_history_code_2024

    FROM voter_details vd
    left join voter_history vh 
    ON vd.voter_id = vh.voter_id 
    and vd.election_year = vh.election_year
    GROUP BY vd.voter_id
)

SELECT * FROM voter_continuity