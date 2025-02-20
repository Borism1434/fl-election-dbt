-- Hash test to ensure table are not duplicates
select md5(STRING_AGG(voter_id || vote_history_code, ',' order by voter_id)) as hash_2016
from voterfile.election_detail_2016

UNION ALL

select md5(STRING_AGG(voter_id || vote_history_code, ',' order by voter_id)) as hash_2024
from voterfile.election_history_2024;