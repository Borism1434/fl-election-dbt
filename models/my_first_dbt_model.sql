
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with test as (

    select voter_id, county
    from "voterfile"."2016_election_detail"
    limit 1000

)

select *
from test
