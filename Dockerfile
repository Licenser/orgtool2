FROM elixir

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

RUN npm install -g brunch

copy LICENSE.auth /
copy README.md /
copy brunch-config.js /
copy config /config
copy lib /lib
copy mix.exs /
copy mix.lock /
copy package.json /

copy priv/repo /priv/repo
copy priv/gettext /priv/gettext

copy test /test
copy web /web

ENV MIX_ENV=prod

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install

COPY docker/prod.secret.exs config/prod.secret.exs

COPY priv/orgtool/dist /priv/static/ui

RUN brunch build \
    && env MIX_ENV=prod mix clean \
    && env MIX_ENV=prod mix phoenix.digest \
    && env MIX_ENV=prod mix compile



COPY docker/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
