# Notes on setting up the database

For more details, see `doc/database.md`.

Om MacOS, with Postgres installed via homebrew, to run postgres as a background
service and restart at login:

```bash
brew services start postgresql
```

To start postgres now:

```bash
pg_ctl -D /usr/local/var/postgres start
```

To create the database for first use:

```bash
createdb hut23-425 "Solar PV database matching"
```

To populate the database:

```bash
psql -f make-database.sql hut23-425
```


