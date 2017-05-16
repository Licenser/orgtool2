#!/bin/bash
set -e

export MIX_ENV=prod

## This is ugly!
sleep 30

## We run create migrate and seed
## if the dagtabase exists, create will fail and no seeding is done
if MIX_ENV=prod mix ecto.create | grep -v already
then
    echo "Initializing Database and running seeds."
    mix ecto.migrate
    mix run priv/repo/rewards.exs
    mix run priv/repo/units.exs
    mix run priv/repo/ships.exs
    mix run priv/repo/seeds.exs
else
    echo "Migrating to ensure database is up to date."
    ## We run migrate again, so when the prior step failed due to
    ## the db already existing
    MIX_ENV=prod mix ecto.migrate
fi

## Now start the server
MIX_ENV=prod mix phoenix.server
