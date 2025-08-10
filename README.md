# MariaDB Hybrid Demo — Graph (OQGRAPH) + Time-Series (ColumnStore)

It stores the **graph** topology with **OQGRAPH** and the **time-series** metrics with **ColumnStore**, then runs a **hybrid query** by exporting graph neighbors and filtering them on the time-series side.

---

## What to build

- **Container A — `mcs1` (ColumnStore)**  
  For time-series: `available_bikes_ts(station_id, ts, value)`  
  + small staging table `pairs_stage(src,dst)` for neighbor pairs
- **Container B — `mariadb_graph` (MariaDB 11.1 + OQGRAPH)**  
  For graph: `trips_backing(origid,destid,weight)` + virtual `trip_graph` + `stations`

---

## 1) Start the containers

### 1.1 ColumnStore (time-series) container

```bash
docker run -d -p 3307:3306 --shm-size=512m -e PM1=mcs1 --hostname=mcs1 --name mcs1 mariadb/columnstore
docker run -d --name mariadb_graph -e MARIADB_ROOT_PASSWORD=root -p 3308:3306 mariadb:11.1 ```bash

#### To enable OQGRAPH:
docker exec -it mariadb_graph bash
apt-get update
apt-get install -y curl gnupg
curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash -s -- --mariadb-server-version='11.1'
apt-get update
apt-get install -y mariadb-plugin-oqgraph libjudydebian1
mariadb -uroot -proot -e "INSTALL SONAME 'ha_oqgraph';"
mariadb -uroot -proot -e "SELECT ENGINE,SUPPORT FROM information_schema.ENGINES WHERE ENGINE='OQGRAPH';"  # expect: YES
exit

