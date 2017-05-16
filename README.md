# OrgtoolDb

## Compiling

### Installing dependencies

```bash
git clone https://github.com/Licenser/orgtool_db
npm install -g brunch yarn bower
cd orgtool_db
mix deps.get
npm install
```

### Fetching and building the UI
```bash
git submodule update --init
cd priv/orgtool
# if you run as root:
# echo '{ "allow_root": true }' > /root/.bowerrc
yarn
node_modules/ember-cli/bin/ember build --prod
cd -
```

### compile static assets

```
brunch build
```


## docker image
If you build a docker image this is now the time to do it!
## Initialize and seed the DB

Warning thistle will delete an existing database!
```
./reseed.db
```

## Start the server

```
mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


# Docker Image


The following environment variables are used for the production config:

* `PORT` - Port to listen to
* `EXT_HOST` - The host from the outside
* `EXT_PORT` - The port form the outside (might differ from `PORT` if say nginx is used)
* `SECRET_KEY_BASE` - secret key for signing cookies

```
docker build -t orgtool .
docker-compose up
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


## making a image
```
docker -t orgtool .
docker tag orgtool orgtool/orgtool
docker push orgtool/orgtool
```
