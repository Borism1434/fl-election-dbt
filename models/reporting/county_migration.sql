 {{ config(materialized='table') }}

with vcm as (
    select * 
    from {{ ref('voter_continuity_model') }}
)

select 
    coalesce(county_2016, county_2018, county_2020, county_2022, county_2024) as county,
    count(distinct case when nullif(county_2016, county_2018) is not null then voter_id end) as moved_in_2018,
    count(distinct case when nullif(county_2018, county_2020) is not null then voter_id end) as moved_in_2020,
    count(distinct case when nullif(county_2020, county_2022) is not null then voter_id end) as moved_in_2022,
    count(distinct case when nullif(county_2022, county_2024) is not null then voter_id end) as moved_in_2024
from vcm
group by county 
order by county