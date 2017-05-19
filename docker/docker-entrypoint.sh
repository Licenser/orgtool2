#!/bin/bash
set -e

export MIX_ENV=prod

## This is ugly!
sleep ${TIMEOUT}

## We run create migrate and seed
## if the dagtabase exists, create will fail and no seeding is done
if MIX_ENV=prod mix ecto.create | grep -v already
then
    echo "Initializing Database and running seeds."
    MIX_ENV=prod mix ecto.migrate
    MIX_ENV=prod mix run priv/repo/rewards.exs
    MIX_ENV=prod mix run priv/repo/units.exs
    MIX_ENV=prod mix run priv/repo/seeds.exs
else
    echo "Migrating to ensure database is up to date."
    ## We run migrate again, so when the prior step failed due to
    ## the db already existing
    MIX_ENV=prod MIX_ENV=prod mix ecto.migrate
fi

echo "Importing/updating data"
MIX_ENV=prod mix run priv/repo/ships.exs


UNIT_PATH=_build/prod/lib/orgtool_db/priv/static/images/unit.png
if [ "${UNIT_LOGO}" != "" ]
then
    echo "Fetching unit logo from ${UNIT_LOGO}."
    curl -L ${UNIT_LOGO} > ${UNIT_PATH}

else
    cp /priv/static/ui/images/unit.png ${UNIT_PATH}
fi

## Now start the server
MIX_ENV=prod elixir --name orgtool@127.0.0.1 --cookie orgtool -S mix phoenix.server
