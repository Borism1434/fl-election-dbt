
-- Ensure reg_date are not out of bound
select max(reg_date) as late_reg_date
from voterfile.election_detail_2016

select max(reg_date) as late_reg_date
from voterfile.election_detail_2018

select max(reg_date) as late_reg_date
from voterfile.election_detail_2020

select max(reg_date) as late_reg_date
from voterfile.election_detail_2022

select voter_id, reg_date 
from voterfile.election_detail_2022
order by reg_date desc

select max(reg_date) as late_reg_date
from voterfile.election_detail_2024s