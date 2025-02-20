 {{ config(materialized='table') }}

 
with voter_details as (
    select voter_id, reg_date, county, party, 2016 as election_year 
    from {{ source('voter_file_source', '2016_election_detail') }}
    union all
    select voter_id, reg_date, county, party, 2018 as election_year 
    from {{ source('voter_file_source', '2018_election_detail') }}
    union all
    select voter_id, reg_date, county, party, 2020 as election_year 
    from {{ source('voter_file_source', '2020_election_detail') }}
    union all
    select voter_id, reg_date, county, party, 2022 as election_year 
    from {{ source('voter_file_source', '2022_election_detail') }}
    union all
    select voter_id, reg_date, county, party, 2024 as election_year 
    from {{ source('voter_file_source', '2024_election_detail') }}
), 

voter_history as (
    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2016 as election_year
    from {{ source('voter_file_source', '2016_election_history') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2018 as election_year
    from {{ source('voter_file_source', '2018_election_history') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2020 as election_year
    from {{ source('voter_file_source', '2020_election_history') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2022 as election_year
    from {{ source('voter_file_source', '2022_election_history') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2024 as election_year
    from {{ source('voter_file_source', '2024_election_history') }}
),

voter_continuity as (
    select 
        vd.voter_id,

        -- Get the earliest registration date
        MIN(reg_date) as reg_date,

        -- Get the first and last year a voter appears
        MIN(vh.election_year) as first_year,
        max(vh.election_year) as last_year,

        -- Aggregate party and county information per voter
        max(case when vh.election_year = 2016 then party end) as party_2016,
        max(case when vh.election_year = 2018 then party end) as party_2018,
        max(case when vh.election_year = 2020 then party end) as party_2020,
        max(case when vh.election_year = 2022 then party end) as party_2022,
        max(case when vh.election_year = 2024 then party end) as party_2024,

        max(case when vh.election_year = 2016 then county end) as county_2016,
        max(case when vh.election_year = 2018 then county end) as county_2018,
        max(case when vh.election_year = 2020 then county end) as county_2020,
        max(case when vh.election_year = 2022 then county end) as county_2022,
        max(case when vh.election_year = 2024 then county end) as county_2024,
        -- Aggregate vote method per election year
        max(case when vh.election_year = 2016 then vh.vote_history_code end) as vote_history_code_2016,
        max(case when vh.election_year = 2018 then vh.vote_history_code end) as vote_history_code_2018,
        max(case when vh.election_year = 2020 then vh.vote_history_code end) as vote_history_code_2020,
        max(case when vh.election_year = 2022 then vh.vote_history_code end) as vote_history_code_2022,
        max(case when vh.election_year = 2024 then vh.vote_history_code end) as vote_history_code_2024

    from voter_details vd
    left join voter_history vh 
    on vd.voter_id = vh.voter_id 
    and vd.election_year = vh.election_year
    group by vd.voter_id
)

select * from voter_continuity