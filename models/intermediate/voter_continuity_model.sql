 {{ config(materialized='table') }}

with voter_details as (
    select voter_id, reg_date, county, party, 2016 as election_year 
    from {{ source('voterfile', 'election_detail_2016') }}
    union all
    select voter_id, reg_date, county, party, 2018 as election_year 
    from {{ source('voterfile', 'election_detail_2018') }}
    union all
    select voter_id, reg_date, county, party, 2020 as election_year 
    from {{ source('voterfile', 'election_detail_2020') }}
    union all
    select voter_id, reg_date, county, party, 2022 as election_year 
    from {{ source('voterfile', 'election_detail_2022') }}
    union all
    select voter_id, reg_date, county, party, 2024 as election_year 
    from {{ source('voterfile', 'election_detail_2024') }}
), 

voter_history as (
    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2016 as election_year,
        vote_date as election_date,
        election_code
    from {{ source('voterfile', 'election_history_2016') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2018 as election_year,
        vote_date as election_date,
        election_code
    from {{ source('voterfile', 'election_history_2018') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2020 as election_year,
        vote_date as election_date,
        election_code
    from {{ source('voterfile', 'election_history_2020') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2022 as election_year,
        vote_date as election_date,
        election_code
    from {{ source('voterfile', 'election_history_2022') }}

    union all

    select 
        voter_id, 
        COALESCE(NULLIF(vote_history_code, ''), 'NV') as vote_history_code,
        2024 as election_year,
        election_date,
        election_code
    from {{ source('voterfile', 'election_history_2024') }}
),

voter_continuity as (
    select 
        vd.voter_id,

        -- Get the earliest registration date
        min(reg_date) as reg_date,

        -- Get the first and last year a voter appears
        min(vh.election_year) as first_year,
        max(vh.election_year) as last_year,

        -- Aggregate party and county information per voter
        max(case when vh.election_year = 2016 and vh.election_code = '10282' and extract(year from vh.election_date) = 2016 then vd.party end) as party_2016,
        max(case when vh.election_year = 2018 and vh.election_code = '10481' and extract(year from vh.election_date) = 2018 then vd.party end) as party_2018,
        max(case when vh.election_year = 2020 and vh.election_code = '10866' and extract(year from vh.election_date) = 2020 then vd.party end) as party_2020,
        max(case when vh.election_year = 2022 and vh.election_code = '26906' and extract(year from vh.election_date) = 2022 then vd.party end) as party_2022,
        max(case when vh.election_year = 2024 and vh.election_code = 'GEN' and extract(year from vh.election_date) = 2024 then vd.party end) as party_2024,

        max(case when vh.election_year = 2016 and vh.election_code = '10282' and extract(year from vh.election_date) = 2016  then vd.county end) as county_2016,
        max(case when vh.election_year = 2018 and vh.election_code = '10481' and extract(year from vh.election_date) = 2018  then vd.county end) as county_2018,
        max(case when vh.election_year = 2020 and vh.election_code = '10866' and extract(year from vh.election_date) = 2020  then vd.county end) as county_2020,
        max(case when vh.election_year = 2022 and vh.election_code = '26906' and extract(year from vh.election_date) = 2022  then vd.county end) as county_2022,
        max(case when vh.election_year = 2024 and vh.election_code = 'GEN' and extract(year from vh.election_date) = 2024  then vd.county end) as county_2024,
        -- Aggregate vote method per election year
        max(case when vh.election_year = 2016 and vh.election_code = '10282' and extract(year from vh.election_date) = 2016 then vh.vote_history_code end) as vote_history_code_2016,
        max(case when vh.election_year = 2018 and vh.election_code = '10481' and extract(year from vh.election_date) = 2018  then vh.vote_history_code end) as vote_history_code_2018,
        max(case when vh.election_year = 2020 and vh.election_code = '10866' and extract(year from vh.election_date) = 2020  then vh.vote_history_code end) as vote_history_code_2020,
        max(case when vh.election_year = 2022 and vh.election_code = '26906' and extract(year from vh.election_date) = 2022  then vh.vote_history_code end) as vote_history_code_2022,
        max(case when vh.election_year = 2024 and vh.election_code = 'GEN' and extract(year from vh.election_date) = 2024 then vh.vote_history_code end) as vote_history_code_2024

    from voter_details vd
    left join voter_history vh 
    on vd.voter_id = vh.voter_id 
    and vd.election_year = vh.election_year
    group by vd.voter_id
)

select * from voter_continuity 
