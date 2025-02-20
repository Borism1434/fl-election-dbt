# Breakdown of `voter_continuity_model`

## Columns

#####	1.	Voter Identification and Registration Information
- voter_id: Unique identifier for each voter.
- reg_date: The earliest recorded registration date for the voter.
- first_year: The earliest election year where the voter was recorded in the voter history.
- last_year: The most recent election year where the voter was recorded in the voter history.
#####	2.	Party Affiliation Over Time
- party_2016, party_2018, party_2020, party_2022, party_2024:
    - These columns store the political party affiliation of the voter in each respective election year.
    - If a voter changed parties over time, this will capture those transitions.
#####	3.	County of Residence Over Time
- county_2016, county_2018, county_2020, county_2022, county_2024:
    - These columns store the county where the voter was registered in each election year.
    - If a voter moved counties between elections, these fields will show those changes.
#####	4.	Voting History by Election Year
- vote_history_code_2016, vote_history_code_2018, vote_history_code_2020, vote_history_code_2022, vote_history_code_2024:
    - These columns capture whether a voter participated in an election and the method of voting (e.g., in-person, absentee).
    - If there is a missing or empty value for vote_history_code, it is replaced with 'NV' (Not Voted).
    - This allows for tracking voter engagement patterns (e.g., who consistently votes, who skips elections, and how they vote).