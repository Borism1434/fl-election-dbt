 {{ config(materialized='table') }}


with geo_voterfile as (
select  *
from {{ source('geo', 'voterfile_042025') }}
),

detail as (
    select *
    from {{ source('monthly_vf', 'detail_042025') }}
),

history as (
    select * 
    from {{ source('monthly_vf', 'history_042025') }}
),

comb_col as (
    select 
        de.voter_id
        , de.residence_zipcode
        , de.gender
        , de.race
        , de.birth_date
        , de.reg_date
        , de.party
        , de.precinct
        , de.congressional_district
        , de.house_district
        , de.senate_district
        , de.county_commission_district
        , de.school_board_district
        , de.email
        , geo.lat 
        , geo.lon
        , geo.status
    from detail de
    left join geo_voterfile geo
    on de.voter_id = geo.voter_id
    where de.voter_status = 'ACT' and de.county = 'DAD'
)

select *
from comb_col
