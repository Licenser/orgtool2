# OrgtoolDb

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Seed your database with `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


# Testing
You can use the docker file in `docker` for testing. The container disables authentication.

```
cd docker
docker build -t orgtool .
docker run -p 4000:4000 orgtool
```

# Running

The following environment variables are used for the production config:

* `PORT` - Port to listen to
* `EXT_HOST` - The host from the outside
* `EXT_PORT` - The port form the outside (might differ from `PORT` if say nginx is used)
* `DB_HOST` - Postgres server
* `DB_NAME` - Database name
* `DB_USER` - Postgres username
* `DB_PASSWORD` - Postgres user password
* `SECRET_KEY_BASE` - secret key for signing cookies

```
cd docker
docker build -t orgtool .
docker run \
  -p 4000:4000 \
  -e "PORT=4000" \
  -e "EXT_HOST=localhost" \
  -e "EXT_PORT=4000" \
  -e "DB_HOST=192.168.1.109" \
  -e "DB_NAME=orgtool_db_dev" \
  -e "DB_USER=postgres" \
  -e "DB_PASSWORD=postgres" \
  -e "SECRET_KEY_BASE=shhhh" \
  orgtool
```


# Installation
## Install dependencies
```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt update
sudo apt install esl-erlang
sudo apt install elixir
sudo apt install postgresql-9.5

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

sudo apt install nodejs
sudo npm install -g yarn
```


## Add Orgtool user
```
sudo useradd -m orgtool
sudo su - org tool
```


## Enable postgres
```
systemctl enable postgresql
echo 'CREATE USER orgtool WITH CREATEDB CREATEROLE CREATEUSER' | sudo -u postgres psql
```


## Install orgtool
```
git clone https://github.com/Licenser/orgtool_db
cd  orgtool_db
mix deps.get
npm install
```

## Setup the DB

```
./reseed-db.sh
```

## Getting the ui
```
git submodule update --init
cd priv/orgtool
yarn
node_modules/ember-cli/bin/ember build --prod
cd -
```


## start the server

```
mix phoenix.server
```
