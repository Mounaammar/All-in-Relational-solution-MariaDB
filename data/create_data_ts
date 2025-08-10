CREATE DATABASE IF NOT EXISTS bike_analytics;
USE bike_analytics;

-- Copy of stations for labeling
CREATE TABLE IF NOT EXISTS stations (
  id       BIGINT UNSIGNED PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  capacity INT NOT NULL
) ENGINE=InnoDB;

REPLACE INTO stations VALUES
  (1,'Central Park',12),
  (2,'Riverside',10),
  (3,'Museum',8);

-- Time-series table (ColumnStore)
CREATE TABLE IF NOT EXISTS available_bikes_ts (
  station_id BIGINT UNSIGNED,
  ts         DATETIME,
  value      INT
) ENGINE=Columnstore;

TRUNCATE available_bikes_ts;

INSERT INTO available_bikes_ts VALUES
 (1,'2025-08-04 10:00:00',3),(1,'2025-08-04 10:10:00',5),(1,'2025-08-04 10:20:00',6),
 (2,'2025-08-04 10:00:00',6),(2,'2025-08-04 10:10:00',4),(2,'2025-08-04 10:20:00',3),
 (3,'2025-08-04 10:00:00',4),(3,'2025-08-04 10:10:00',4),(3,'2025-08-04 10:20:00',5);

-- Permanent staging table for neighbor pairs (needed for the cross-query)
CREATE TABLE IF NOT EXISTS pairs_stage (
  src BIGINT UNSIGNED,
  dst BIGINT UNSIGNED,
  PRIMARY KEY (src,dst)
) ENGINE=InnoDB;
