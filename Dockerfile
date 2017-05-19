FROM elixir

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

RUN npm install -g brunch

COPY be/brunch-config.js /
COPY be/config /config
COPY be/lib /lib
COPY be/mix.exs /
COPY be/mix.lock /
COPY be/package.json /

COPY be/priv/repo /priv/repo
COPY be/priv/gettext /priv/gettext

COPY be/test /test
COPY be/web /web

COPY docker/prod.secret.exs config/prod.secret.exs

COPY fe/dist /priv/static/ui

ENV MIX_ENV=prod

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install \
    && brunch build \
    && env MIX_ENV=prod mix clean \
    && env MIX_ENV=prod mix phoenix.digest \
    && env MIX_ENV=prod mix compile \
    && rm -rf root/.cache \
    && rm -rf root/.npm

COPY docker/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
