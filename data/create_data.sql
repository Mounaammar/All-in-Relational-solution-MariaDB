CREATE DATABASE IF NOT EXISTS graphdb;
USE graphdb;

-- Node attributes
CREATE TABLE IF NOT EXISTS stations (
  id       BIGINT UNSIGNED PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  capacity INT NOT NULL
) ENGINE=InnoDB;

-- Backing edges (OQGRAPH)
CREATE TABLE IF NOT EXISTS trips_backing (
  origid BIGINT UNSIGNED NOT NULL,
  destid BIGINT UNSIGNED NOT NULL,
  weight DOUBLE NOT NULL DEFAULT 1,
  PRIMARY KEY (origid, destid),
  KEY (destid)
) ENGINE=InnoDB;

-- Virtual OQGRAPH table 
CREATE TABLE IF NOT EXISTS trip_graph (
  latch  VARCHAR(32),
  origid BIGINT UNSIGNED,
  destid BIGINT UNSIGNED,
  weight DOUBLE,
  seq    BIGINT UNSIGNED,
  linkid BIGINT UNSIGNED,
  KEY (latch,origid,destid) USING HASH,
  KEY (latch,destid,origid) USING HASH
) ENGINE=OQGRAPH
  data_table='trips_backing'
  origid='origid'
  destid='destid'
  weight='weight';

-- Add nodes
REPLACE INTO stations VALUES
  (1,'Central Park',12),
  (2,'Riverside',10),
  (3,'Museum',8);

-- Add directed edges
REPLACE INTO trips_backing VALUES
  (1,2,1),(1,3,1),(2,1,1),(2,3,1),(3,1,1);
