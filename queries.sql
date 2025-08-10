-- find the bike stations with neighbors who have low availability on a given timestamp 
USE bike_analytics;

WITH latest AS (
  SELECT station_id, MAX(ts) AS ts
  FROM available_bikes_ts
  WHERE ts <= TIMESTAMP('2025-08-04 10:20:00')
  GROUP BY station_id
),
snap AS (
  SELECT m.station_id, m.value
  FROM available_bikes_ts m
  JOIN latest l ON l.station_id = m.station_id AND l.ts = m.ts
)
SELECT ssrc.name AS src,
       GROUP_CONCAT(sdst.name ORDER BY sdst.name) AS low_neighbors
FROM pairs_stage p
JOIN stations ssrc ON ssrc.id = p.src
JOIN stations sdst ON sdst.id = p.dst
JOIN snap          ON snap.station_id = p.dst
WHERE snap.value <= 3
GROUP BY ssrc.id, ssrc.name
ORDER BY ssrc.id;
