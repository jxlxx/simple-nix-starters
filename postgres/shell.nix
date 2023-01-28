let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [
        pkgs.postgresql
        # optionally include dbeaver to manage db
        # pkgs.dbeaver
    ];
  shellHook = ''
      chmod a+x ./scripts/*.sh;
      export PGHOST=$PWD/postgres
      export PGDATA=$PWD/postgres_data
      export PGLOG=$PGHOST/postgres.log

      # CHANGE ME
      export PGDATABASE=db_name
  '';
}
