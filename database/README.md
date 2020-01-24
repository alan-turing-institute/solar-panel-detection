# Notes on setting up the database

To run postgres as a background service and restart at login:
```bash
brew services start postgresql
```

To start now:
```bash
pg_ctl -D /usr/local/var/postgres start
```

