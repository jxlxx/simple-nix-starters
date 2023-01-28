

# create the postgres directory
if [ ! -d $PGHOST ]; then
  echo "Creating $PGHOST"
  mkdir -p $PGHOST
else
  echo "$PGHOST directory exists. Skipping."
fi

# Create a database with the data stored in $PGDATA
if [ ! -d $PGDATA ]; then
  initdb --auth=trust --no-locale --encoding=UTF8 -D $PGDATA
else
  echo `$PGDATA db exists. Skipping.`
fi

# Start PostgreSQL running as the current user
# and with the Unix socket in the current directory
pg_ctl  -l $PGLOG -o "--unix_socket_directories='$PGHOST'" start

# Create a database
createdb $PGDATABASE


