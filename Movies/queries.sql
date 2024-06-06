USE movies;
SHOW TABLES;

-- exploring movie table.
SELECT count(*) FROM movie;
select * from movie where budget > 10000000;
select * from movie where popularity > 100;
select * from movie where runtime < 60;
select movie_status, count(*) from movie group by movie_status;
select * from movie where movie_status LIKE '%Post%';
select * from movie where homepage <> ' ';

-- exploring movie_cast table
select * from movie_cast where movie_id = 285;
select movie_id, count(person_id) from movie_cast group by movie_id;
select person_id, character_name, count(movie_id) from movie_cast group by person_id, character_name;


-- movie budget per minute | runtime is in mintue
select 	title, 
		budget, 
		runtime,  
		round((budget / runtime), 0) as "Budget_Per_Mintue"
	from movie;

-- top 10 movies by budget 
select * 
	from movie 
    order by budget desc
    limit 10;
    
-- max budget
select title, budget
	from movie 
    where budget = (select max(budget) from movie);
    
-- movies by release_date -- oldest & most recent 
select title,  release_date, (year(curdate()) - year(release_date)) as How_old_in_years
	from movie
    order by 3 asc
    limit 10;

select title,  release_date, (year(curdate()) - year(release_date)) as How_old_in_years
	from movie
    order by 3 desc
    limit 1,10;
    
-- count movies per year
select  year(release_date), 
		count(movie_id)
	from movie
    group by year(release_date)
    order by 2 desc;

-- last ten films by popularity
select title, sum(popularity), company_name
	from movie mv 
    join movie_company mc 
    on mv.movie_id = mc.movie_id
    join production_company pc on
    mc.company_id = pc.company_id 
    group by title, company_name
    order by 2
    limit 10;



-- count movies by company 
select company_name, mc.company_id, count(mv.movie_id)
	from movie mv 
		join movie_company mc 
		on mv.movie_id = mc.movie_id
		join production_company pc 
        on mc.company_id = pc.company_id
    group by
		company_name,
        mc.company_id
	order by 
		mc.company_id;
        
    
-- movie budget and genre 
select t1.movie_id, t1.title, t3.genre_name, t1.budget
		from movie t1
		join movie_genres t2 
		on t1.movie_id = t2.movie_id
        join genre t3 
        on t2.genre_id = t3.genre_id
	where 
		t1.budget < 100000 and 
        t1.budget > 5000
        order by t1.budget desc;

-- count movies in each genre 
select t3.genre_name, count(t1.movie_id)
		from movie t1
			join movie_genres t2 
			on t1.movie_id = t2.movie_id
			join genre t3 
			on t2.genre_id = t3.genre_id
		group by 
			t3.genre_name;
            
-- popular movies in english and other language with person name
select person_name, language_name, count(*) as total
	from movie t1 
		join movie_crew t2 
		on t1.movie_id = t2.movie_id 
		join person t3 
		on t2.person_id = t3.person_id 
		join movie_languages t4 
		on t1.movie_id = t4.movie_id 
        join language t5 
        on t4.language_id = t5.language_id
		group by person_name, language_name;

-- movies with all characters and actors
select t1.movie_id, t1.title, t2.character_name, t3.person_name
	from movie  t1
    join movie_cast t2 
    on t1.movie_id = t2.movie_id
    join person t3
    on t3.person_id = t2.person_id 
    where t1.movie_id = 285;
    











