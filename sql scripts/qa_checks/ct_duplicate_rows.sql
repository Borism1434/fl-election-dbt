-- counts of duplicates in voter_id

select voter_id, count(*) as record_count
from voterfile.election_detail_2016
GROUP BY voter_id
HAVING count(*) > 1
order by record_count DESC;


select voter_id, count(*) as record_count
from voterfile.election_detail_2018
GROUP BY voter_id
HAVING count(*) > 1
order by record_count DESC;


select voter_id, count(*) as record_count
from voterfile.election_detail_2020
GROUP BY voter_id
HAVING count(*) > 1
order by record_count DESC;


-- Looking at duplicate voter_id records

SELECT *
FROM voterfile.election_detail_2016
WHERE voter_id IN (
    SELECT voter_id
    FROM voterfile.election_detail_2016
    GROUP BY voter_id
    HAVING COUNT(*) > 1
)
ORDER BY voter_id;

SELECT *
FROM voterfile.election_detail_2022
WHERE voter_id IN (
    SELECT voter_id
    FROM voterfile.election_detail_2022
    GROUP BY voter_id
    HAVING COUNT(*) > 1
)
ORDER BY voter_id;