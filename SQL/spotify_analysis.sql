-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
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


-- EDA 
SELECT COUNT(*) FROM spotify;

SELECT COUNT( DISTINCT artist) FROM spotify;

SELECT COUNT( DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT DISTINCT MAX(duration_min) FROM spotify;

SELECT DISTINCT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0 ;

DELETE FROM spotify 
WHERE duration_min = 0 ;

SELECT * FROM spotify
WHERE duration_min = 0 ;



-- --------------------------
-- Data Analysis - easy -
-- --------------------------

--q1 Retrieve the names of all tracks that have more than 1 billion streams.

SELECT
	track
FROM
	spotify
WHERE
	stream > 1000000000;



-- q2 List all albums along with their respective artists.
SELECT DISTINCT
	album,
	artist
FROM
	spotify;

-- q3 Get the total number of comments for tracks where licensed = TRUE
SELECT
	SUM(comments) AS total_comment
FROM
	spotify
WHERE
	licensed = TRUE;

-- q4 Find all tracks that belong to the album type single
SELECT
	track
FROM
	spotify
WHERE
	album_type = 'single' ;

-- q5 Count the total number of tracks by each artist.
SELECT
	artist,
	COUNT(*) AS total_no_songs
FROM
	spotify
GROUP BY
	artist;

-- q6 Retrieve all tracks with more than 500 million streams.
SELECT
	track , stream
FROM
	spotify
WHERE
	stream > 500000000;

-- q7 Find all tracks where official_video = TRUE.
SELECT
	track
FROM
	spotify
WHERE
	official_video = TRUE;
	
-- q8 List all albums of type album.
SELECT DISTINCT
	album
FROM
	spotify
WHERE
	album_type = 'album';
	
-- q9 Display all tracks by Ed Sheeran.
SELECT
	track,
	artist
FROM
	spotify
WHERE
	artist = 'Ed Sheeran';

-- q10 Find tracks whose duration is greater than 5 minutes.
SELECT
	track,
	duration_min AS duration
FROM
	spotify
WHERE
	duration_min > 5;

--q11 Show all tracks sorted by streams (highest first).
SELECT
	track,
	stream
FROM
	spotify
ORDER BY
	stream DESC;
	
-- q12 List the top 20 most streamed tracks.
SELECT
	track
FROM
	spotify
ORDER BY
	stream DESC
LIMIT
	20;

-- q13 Find tracks with energy greater than 0.8.
SELECT
	track
FROM
	spotify
WHERE
	energy > 0.8;


-- --------------------------
-- Data Analysis - Medium -
-- --------------------------

-- q1 Find the average danceability of all tracks.
SELECT
    AVG(danceability) AS avg_danceability
FROM spotify;

-- q2 Find the average energy of all tracks.
SELECT
	AVG(energy) AS avg_enery
FROM
	spotify;

-- q3 Find the total number of views.
SELECT
	SUM(views) AS total_views
FROM
	spotify;

-- q4 Find the total number of likes.
SELECT
	SUM(likes) AS total_likes
FROM
	spotify;

-- q5 Find the total number of comments.
SELECT
	SUM(comments) AS total_comments
FROM
	spotify;

-- q6 Find the highest stream count.
-1
SELECT
	MAX(stream) AS highest_stream
FROM
	spotify;

-2	

SELECT
	stream
FROM
	spotify
ORDER BY
	stream DESC
LIMIT
	1;

-- q7 Find the lowest stream count.
-1
SELECT
	MIN(stream) AS lowest_stream
FROM
	spotify;

-2	

SELECT
	stream
FROM
	spotify
ORDER BY
	stream ASC
LIMIT
	1;

-- q8 Find the average duration of tracks.
SELECT
	AVG(duration_min) AS avg_duration_min
FROM
	spotify;

-- q9 Find the total streams of licensed tracks.
SELECT
	SUM(stream) AS total_streams
FROM
	spotify
WHERE
	licensed = 'True';

-- q10 Count how many official videos exist.
SELECT
    COUNT(*)
FROM spotify
WHERE official_video = TRUE;

-- q11 Calculate the average danceability of tracks in each album.
SELECT
	album,
	AVG(danceability) AS avg_danceability
FROM
	spotify
GROUP BY
	album;

-- q12 Find the top 5 tracks with the highest energy values.
SELECT
	track,
	energy
FROM
	spotify
ORDER BY
	energy DESC
LIMIT
	5;

-- q13 List all tracks along with their views and likes where official_video = TRUE.
SELECT
	track,
	views,
	likes
FROM
	spotify
WHERE
	official_video = TRUE;

-- q14 For each album, calculate the total views of all associated tracks.
SELECT
	album,
	SUM(views) AS total_views
FROM
	spotify
GROUP BY
	album;

-- q15 Retrieve the track names that have been streamed on Spotify more than YouTube.
--1
select track 
from spotify
where stream > views;
--2
SELECT
    track
FROM spotify
WHERE most_played_on = 'Spotify';


-- --------------------------
-- Data Analysis - Advanced -
-- --------------------------

-- q1 Find the top 3 most-viewed tracks for each artist using window functions.
WITH
	ranked_tracks AS (
		SELECT
			artist,
			track,
			views,
			ROW_NUMBER() OVER (
				PARTITION BY
					artist
				ORDER BY
					views DESC
			) AS rn
		FROM
			spotify )
			
		SELECT
		artist,
		track,
		views
			FROM
				ranked_tracks
			WHERE
				rn <= 3
			ORDER BY
				artist,
				rn;
				
-- q2 Write a query to find tracks where the liveness score is above the average.
select track , liveness
from spotify 
where liveness >
	(SELECT
		AVG(liveness)
	FROM
		spotify)  ;
		
-- q3 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with energy_stats as (
	select album , max(energy)- min(energy) as diff from spotify 
group by album 
) 
select album , diff
from energy_stats ;

-- q4 Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT
	energy,
	liveness,
	energy / liveness AS energy_to_liveness
FROM
	spotify
WHERE
	energy / liveness > 1.2
ORDER BY
	energy_to_liveness DESC;

;

-- q5 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT
    track,
    views,
    likes,
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM spotify;




-- ---------------------------------
-- Data Analysis - Interview-Level -
-- ---------------------------------

--q1 Find tracks with streams greater than the average stream count.
SELECT
	track,
	stream
FROM
	spotify
WHERE
	stream > (
		SELECT
			AVG(stream) 
		FROM
			spotify
	);

--q2 Find the artist with the highest average views.
SELECT
	artist,
	AVG(VIEWs) AS avg_view
FROM
	spotify
GROUP BY
	artist
ORDER BY
	avg_view DESC
LIMIT
	1;

--q3 Find the album with the highest total streams.
SELECT
	album,
	SUM(stream) AS total_streams
FROM
	spotify
GROUP BY
	album
ORDER BY
	total_streams DESC
LIMIT
	1;
	
--q4 Find artists who have both licensed and unlicensed tracks.
SELECT
    artist
FROM spotify
GROUP BY artist
HAVING
    COUNT(CASE WHEN licensed = TRUE THEN 1 END) > 0
    AND
    COUNT(CASE WHEN licensed = FALSE THEN 1 END) > 0;

--q5 Find tracks where likes are greater than comments.
SELECT
	track,
	likes,
	comments
FROM
	spotify
WHERE
	likes > comments;
	
--q6 Find the most popular track (highest streams) of each artist.
WITH
	cte AS (
		SELECT
			artist,
			track,
			stream,
			ROW_NUMBER() OVER (
				PARTITION BY
					artist
				ORDER BY
					stream DESC
			) AS rn
		FROM
			spotify
	)
SELECT
	artist,
	track,
	stream
FROM
	cte
WHERE
	rn = 1;

--q7 Find the top 3 tracks of every artist based on streams.
WITH
	top_3 AS (
		SELECT
			track,
			stream,
			artist,
			DENSE_RANK() OVER (
				PARTITION BY
					artist
				ORDER BY
					stream DESC
			) AS rn
		FROM
			spotify
	)
SELECT
	artist,
	track,
	stream
FROM
	top_3
WHERE
	rn <= 3;
	
--q8 Rank artists based on total streams.
SELECT
    artist,
    SUM(stream) AS total_stream,
    RANK() OVER (
        ORDER BY SUM(stream) DESC
    ) AS artist_rank
FROM spotify
GROUP BY artist;

--q9 Find the percentage of licensed tracks.
SELECT
(select count(track) from spotify 
where licensed = true ) *100.0 / 
(select count(track) from spotify) as  licensed_per

--q10 Create a report showing, for every artist:
-- Number of tracks
-- Total streams
-- Total views
-- Total likes
-- Total comments
-- Average danceability
-- Average energy
SELECT
	artist,
	COUNT(track) AS no_of_tracks,
	SUM(stream) AS total_streams,
	SUM(views) AS total_views,
	SUM(likes) AS total_like,
	SUM(COMMENTS) AS total_comments,
	AVG(danceability) AS avg_danceability,
	AVG(energy) AS avg_energy
FROM
	spotify
GROUP BY
	artist;