-- Ensure vote_date are not out of bound
select max(vote_date) as late_vote_date
from voterfile.election_history_2016

select max(vote_date) as late_vote_date
from voterfile.election_history_2018

select max(vote_date) as late_vote_date
from voterfile.election_history_2020

select max(vote_date) as late_vote_date
from voterfile.election_history_2022