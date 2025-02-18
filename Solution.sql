Project Sql: spotify

-- create table

create table spotify(
	Artist varchar(255),
	Track varchar(255),
	Album varchar(255),
	Album_type varchar(50),
	Danceability float,
	Energy float,
	Loudness float,
	Speechiness float,
	Acousticness float,	
	Instrumentalness float,	
	Liveness float,
	Valence float,
	Tempo float,
	Duration_min float,
	Title varchar(255),
	Channel varchar (255),
	Views float,
	Likes bigint,
	Comments bigint,
	Licensed boolean,
	official_video boolean,
	Stream bigint,
	Energy_Liveness float,
	most_playedon varchar(50)
);

select * from spotify;


-- EDA 
select count(*) from spotify;

select count(distinct artist) from spotify;

select count(distinct album) from spotify;

select distinct album_type from spotify;

select max(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0;

select distinct channel from spotify; 


-- -------------------------
-- DATA ANALYST
-- -------------------------

-- Q.1 Retrieve the names of all tracks that have 1 billion streams
select * from spotify
where stream >= 1000000000;


-- Q.2 List all albums along with their respective artist
select 
	distinct album,
	artist
from spotify
order by 1 asc; 



-- Q.3 Get the total number of comments for tracks where licensed 'TRUE'
select
	sum(comments) as total_comment
from spotify
where licensed = 'TRUE';


-- Q.4 Find all tracks that belong to the album type single 
select * from spotify
where album_type = 'single'


-- Q.5 Count the total number of tracks by each artist
select 
	artist,
	count(track) as number_of_songs 
from spotify
group by 1
order by 1;



-- Q.6 Calculate the average danceability of tracks on each album
select 
	album,
	avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;



-- Q.7 Find the TOP 5 tracks with the highest energy volues
select 
	track,
	max(energy)
from spotify
group by 1
order by 2 desc
limit 5;



-- Q.8 List all tracks along with their views and likes where official_video = TRUE
select  
	track,
	sum(views) as total_views,
	sum(likes) as total_likes
from spotify
where official_video = 'TRUE'
group by 1
order by 2 desc;




-- Q.9 For each album, calculate the total views of all associated tracks
select
	album,
	track,
	sum (views) as total_views
from spotify
group by 1, 2
order by 2 desc;



-- Q.10 Retrieve the track names that have been streamed on Spotify more than youtube()
select * from
(select 
	track,
	coalesce(sum(case when most_playedon = 'Youtube' then stream end), 0) as streamed_on_youtube,
	coalesce(sum(case when most_playedon = 'Spotify' then stream end), 0) as streamed_on_spotify
from spotify
group by 1) as t1
where 
	streamed_on_spotify > streamed_on_youtube
	and 
	streamed_on_youtube <> 0
;



-- Q.11 Find the TOP 3 most viewed track for each artist using window functions.
with ranking_artist
as
(select 
	artist,
	track,
	sum(views) as total_view,
	dense_rank() over(partition by artist order by sum(views) desc) as rank 
from spotify
group by 1, 2
order by 1, 3 desc
)
select * from ranking_Artist
where rank <= 3



-- Q.12 Write a querry to find tracks where the liveness score is above the average
select 
	track,
	artist,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify)
;



-- Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each allbum
with cte
as
(select
	album,
	max(energy) as highest_energy,
	min(energy) as lowest_energy
from spotify
group by 1)
select 
	album,
	highest_energy - lowest_energy as energy_different
from cte
order by 2 desc




-- Q.14 Find tracks where the energy to liveness ratio is greater than 1.2.
with ratio_table
as
(select 
	track,
	energy/nullif(liveness, 0) as energy_to_liveness_ratio
from spotify)
select *
from ratio_table
where 
	energy_to_liveness_ratio > 1.2



-- Q.15 Calculate the cumulative sum of the likes for tracks ordered by the number of views, using window function
select 
	track,
	views,
	sum(likes) over (order by views) as total_likes
from spotify
order by 2 desc;

SELECT 
	track,
	SUM(likes) OVER (ORDER BY views) AS cumulative_sum
FROM Spotify
	ORDER BY SUM(likes) OVER (ORDER BY views) DESC ;




