# Postgres upgrade from v12 to v16

## Kepler testnet was use 12v of postgresql but on mainnet we are migration to v16. So for continue and migrate to mainnet indexer musr convert their databases to actual version.


### Step1. Full stop indexer
```
./tools/stop_all
./tools/tool_stop_all_projects
```

### Step2. Setup requirements 
```
apt install -y tmux
```

### Step3. start migration process(convert postgres database 12 to 16. May take some time)
```
tmux new
mkdir .data/postgres16
docker run --rm -v .data/postgres:/var/lib/postgresql/12/data -v .data/postgres16:/var/lib/postgresql/16/data tianon/postgres-upgrade:12-to-16 --link
```

### Step4. Finalize migration process. Please run it after previous task ic complete
```
mv .data/postgres .data/postgres_old
mv .data/postgres16 .data/postgres
echo 'POSTGRES_VERSION="postgres:16-alpine"' >> .PACKAGE_USE
```