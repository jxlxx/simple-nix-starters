# Postgres + Nix

This directory contains a very simple `shell.nix` file to run a local postgres instance (for testing/development).

To use it, update the `PGDATABASE` variable with your desired database name.

Then, create the database by running the init script ("./scripts/init.sh").

There are also scripts to restart and stop your database.

You should also probably update your `.gitignore` file to ignore:
- `/postgres`
- `/postgres_data`

To delete the database, delete the aformentioned directories.


