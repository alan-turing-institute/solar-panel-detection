# Notes on setting up the database

To run postgres as a background service and restart at login:
```bash
brew services start postgresql
```

To start now:
```bash
pg_ctl -D /usr/local/var/postgres start
```

To create the database for first use:
```bash
createdb hut23-425 "Solar PV database matching"
```

To create the database:
```bash
psql -f solar_db.sql hut23-425
```


