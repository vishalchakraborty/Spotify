-- Advance SQL Project



CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,   -- FLOAT is for the decimal number
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA   THESE ARE THE BASIC EXPLORATION

SELECT COUNT(*) FROM SPOTIFY;


SELECT COUNT(DISTINCT ARTIST) FROM SPOTIFY;

SELECT COUNT(DISTINCT ALBUM) FROM SPOTIFY;

SELECT DISTINCT ALBUM_TYPE FROM SPOTIFY;


SELECT MAX(DURATION_MIN) ,MIN(DURATION_MIN) FROM SPOTIFY

SELECT * FROM SPOTIFY WHERE DURATION_MIN = 0

DELETE FROM SPOTIFY  WHERE DURATION_MIN = 0



SELECT DISTINCT CHANNEL FROM SPOTIFY

SELECT DISTINCT most_played_on FROM SPOTIFY 

----------------=====================================================

--  Data Analysis -Easy Category

-- Q1 Retrieve the names of all tracks that have more than 1 billion streams.

Select * From Spotify where stream > 1000000000

select * from spotify

-- Q2 List all albums along with their respective artists.

SELECT DISTINCT artist , album from spotify
  ORDER BY 1


SELECT DISTINCT ALBUM FROM SPOTIFY

-- Q3 Get the total number of comments for tracks where licensed = TRUE.

SELECT count(comments) as True_comments FROM SPOTIFY WHERE LICENSED = 'true'  

Select SUM(Comments) as Total_comments 
  FROM SPOTIFY 
    WHERE LICENSED = 'true'


-- Q5 Find all tracks that belong to the album type single.

SELECT * FROM SPOTIFY WHERE ALBUM_TYPE = 'single'

-- Q6 Count the total number of tracks by each artist.

SELECT ARTIST ,COUNT(TRACK)FROM SPOTIFY  GROUP BY ARTIST
  ORDER BY 2

-- ====================================================================================================
 --            MEDIUM LEVEL QUESTIONS


-- Q 6 Calculate the average danceability of tracks in each album.

SELECT ALBUM ,AVG(DANCEABILITY) AS Average_Danceability
   FROM SPOTIFY
    GROUP BY ALBUM
	   ORDER BY Average_Danceability


SELECT * FROM SPOTIFY
 
-- Q7 Find the top 5 tracks with the highest energy values.

SELECT TRACK ,MAX(ENERGY) AS ENERY_S FROM SPOTIFY  
  GROUP BY TRACK
     ORDER BY 2 DESC 
               LIMIT 5



-- Q8 List all tracks along with their views and likes where official_video = TRUE.

SELECT TRACK, sum(VIEWS) as Total_view , sum(LIKES) as Total_like
     FROM SPOTIFY
        WHERE official_video = 'true'
                            group by 1

-- Q9 For each album, calculate the total views of all associated tracks.

SELECT ALBUM, TRACK, SUM(VIEWS) FROM SPOTIFY
   GROUP BY 1 , 2
  

-- Q10 Retrieve the track names that have been streamed on Spotify more than YouTub

SELECT * FROM 
(SELECT TRACK ,
      -- MOST_PLAYED_ON ,

	COALESCE( SUM (CASE WHEN most_played_on = 'Youtube' then Stream END ),0)as stream_on_youtube,
	  COALESCE(SUM (CASE WHEN most_played_on = 'Spotify' then Stream END ),0)as stream_on_SPOTIFY
   
FROM SPOTIFY
GROUP BY 1
)  AS T1 

WHERE
  stream_on_spotify >   stream_on_Youtube
AND
   stream_on_youtube <> 0


--============================================================================================================================================

--   ========================ADVANCE LEVEL QUESTION==================================


-- Q 11 Find the top 3 most-viewed tracks for each artist using window functions.

SELECT * FROM SPOTIFY


SELECT ARTIST , TRACK,SUM(VIEWS)
   FROM SPOTIFY
      GROUP BY 1 ,2
	    ORDER BY 1 , 3 DESC
-- =----------------------=-----------------------------------------------------
--   Each artists and total view for each track
--  track with highest view for each artist ( we need top 3)
--  dense rank
--  cte and filter rank <=3

With ranking_artist
AS
(
SELECT  
    artist , 
     track ,
	   SUM(views) as total_views,
	      DENSE_RANK() OVER(PARTITION BY ARTIST ORDER BY SUM(VIEWS) DESC ) AS Ra
from spotify
GROUP BY 1, 2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE rank <= 3
	

-- Q 12 Write a query to find tracks where the liveness score is above the average.

select * from spotify
SELECT AVG(LIVENESS) FROM SPOTIFY  -- 0.19

-- PUTTING SUBQUERY
SELECT TRACK, ARTIST, LIVENESS FROM SPOTIFY WHERE LIVENESS > (SELECT AVG(LIVENESS) FROM SPOTIFY )


-- Q 13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.


SELECT 
    ALBUM,
	MAX(ENERGY) AS HIGHEST, MIN(ENERGY) AS LOWEST,
FROM SPOTIFY
GROUP BY ALBUM
--------------------------------------------------------

WITH energy_stats AS (
    SELECT 
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM SPOTIFY
    GROUP BY album
)
SELECT 
    album,
    max_energy - min_energy AS energy_difference
FROM energy_stats
order by 2 desc;


-- Q 14 Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT *
FROM Spotify
WHERE (energy / liveness) > 1.2;

-- Q 15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.


SELECT 
    Track,
	Likes,
    Views,
    SUM(Likes) OVER (ORDER BY Views) AS cumulative_likes
FROM Spotify
Order by cumulative_likes desc;






   