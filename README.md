# Spotify-SQL-project

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
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
```

## Project Steps

### Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.

Optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **7 ms**
        - Planning time (P.T.): **0.17 ms**
  
- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
     

This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.
---

### Q.1 Retrieve the names of all tracks that have 1 billion streams
``` sql
select * from spotify
where stream >= 1000000000;
```


### Q.2 List all albums along with their respective artist
``` sql
select 
	distinct album,
	artist
from spotify
order by 1 asc; 
```


### Q.3 Get the total number of comments for tracks where licensed 'TRUE'
``` sql
select
	sum(comments) as total_comment
from spotify
where licensed = 'TRUE';
``` 

### Q.4 Find all tracks that belong to the album type single 
``` sql
select * from spotify
where album_type = 'single'
``` 


 ### Q.5 Count the total number of tracks by each artist
``` sql
select 
	artist,
	count(track) as number_of_songs 
from spotify
group by 1
order by 1;
``` 

### Q.6 Calculate the average danceability of tracks on each album
``` sql
select 
	album,
	avg(danceability) as avg_danceability
from spotify
group by 1
order by 2 desc;
```


### Q.7 Find the TOP 5 tracks with the highest energy volues
``` sql
select 
	track,
	max(energy)
from spotify
group by 1
order by 2 desc
limit 5;
```


### Q.8 List all tracks along with their views and likes where official_video = TRUE
``` sql
select  
	track,
	sum(views) as total_views,
	sum(likes) as total_likes
from spotify
where official_video = 'TRUE'
group by 1
order by 2 desc;
```


### Q.9 For each album, calculate the total views of all associated tracks
``` sql
select
	album,
	track,
	sum (views) as total_views
from spotify
group by 1, 2
order by 2 desc;
```


### Q.10 Retrieve the track names that have been streamed on Spotify more than youtube()
``` sql
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
	streamed_on_youtube <> 0;
```


### Q.11 Find the TOP 3 most viewed track for each artist using window functions.
``` sql
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
where rank <= 3;
```


### Q.12 Write a querry to find tracks where the liveness score is above the average
``` sql
select 
	track,
	artist,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify);
```


### Q.13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each allbum
``` sql
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
```


### Q.14 Find tracks where the energy to liveness ratio is greater than 1.2.
``` sql
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
```


### Q.15 Calculate the cumulative sum of the likes for tracks ordered by the number of views, using window function
``` sql
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
	ORDER BY SUM(likes) OVER (ORDER BY views) DESC;
```


## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor)
---
