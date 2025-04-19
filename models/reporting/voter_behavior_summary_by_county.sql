{{ config(materialized='table', schema='fl-analytics') }}

with vcm as (
    select *
    from {{ ref('voter_continuity_model') }}
)

select
    -- Determine the most recent known county
    coalesce(county_2016, county_2018, county_2020, county_2022, county_2024) as county,

    -- county-level voter migration
    count(distinct case when county_2016 is distinct from county_2018 then voter_id end) as moved_in_2018,
    count(distinct case when county_2018 is distinct from county_2020 then voter_id end) as moved_in_2020,
    count(distinct case when county_2020 is distinct from county_2022 then voter_id end) as moved_in_2022,
    count(distinct case when county_2022 is distinct from county_2024 then voter_id end) as moved_in_2024,

    -- county-level party switches: Democrat → Republican
    count(distinct case when party_2016 = 'DEM' and party_2018 = 'REP' then voter_id end) as switch_dem_rep_2018,
    count(distinct case when party_2018 = 'DEM' and party_2020 = 'REP' then voter_id end) as switch_dem_rep_2020,
    count(distinct case when party_2020 = 'DEM' and party_2022 = 'REP' then voter_id end) as switch_dem_rep_2022,
    count(distinct case when party_2022 = 'DEM' and party_2024 = 'REP' then voter_id end) as switch_dem_rep_2024,
    -- REP → Dem switches 
    count(distinct case when party_2016 = 'REP' and party_2018 = 'DEM' then voter_id end) as switch_rep_dem_2018,
    count(distinct case when party_2018 = 'REP' and party_2020 = 'DEM' then voter_id end) as switch_rep_dem_2020,
    count(distinct case when party_2020 = 'REP' and party_2022 = 'DEM' then voter_id end) as switch_rep_dem_2022,
    count(distinct case when party_2022 = 'REP' and party_2024 = 'DEM' then voter_id end) as switch_rep_dem_2024,
    -- DEM → non-REP (independent/other) switches
    count(distinct case when party_2016 = 'DEM' and party_2018 is distinct from 'DEM' and party_2018 != 'REP' then voter_id end) as switch_dem_ind_2018,
    count(distinct case when party_2018 = 'DEM' and party_2020 is distinct from 'DEM' and party_2020 != 'REP' then voter_id end) as switch_dem_ind_2020,
    count(distinct case when party_2020 = 'DEM' and party_2022 is distinct from 'DEM' and party_2022 != 'REP' then voter_id end) as switch_dem_ind_2022,
    count(distinct case when party_2022 = 'DEM' and party_2024 is distinct from 'DEM' and party_2024 != 'REP' then voter_id end) as switch_dem_ind_2024
    

from vcm
group BY 1
order BY 1