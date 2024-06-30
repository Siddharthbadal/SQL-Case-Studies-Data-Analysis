-- show all applications for queue Consumer Existing.
-- Queue_id has CE code for Consumer Existing
select * 
from fact_applications
where queue_id='CE';

-- total count for aove query
select queue_id, count(*)
from fact_applications
where queue_id='CE'
group by 1;

-- from above query find the approved applications
-- outcome_id has code 'A' for approved
select * 
from fact_applications
where queue_id='CE' and
		outcome_id = 'A';

-- total count for consumer existing and approved applications
select queue_id, count(*) as Total_applications
from fact_applications
where queue_id='CE' and
		outcome_id = 'A'
group by queue_id;


-- seperate date and time
select 
	date_format(date_actioned, '%Y-%m-%d') as Date,
	date_format(date_actioned, '%H:%i:%s') as Time
from fact_applications;


-- show all apps that were actioned between 1st Aug - 30th Aug
select *
	from fact_applications
    where day(date(date_actioned)) between '1' and '10';

-- decline applications 
select *
	from fact_applications
    where day(date(date_actioned)) between '1' and '10'
    and
    outcome_id = 'D';
    
select *
	from fact_applications








