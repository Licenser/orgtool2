FROM elixir

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

RUN npm install -g brunch

copy be/brunch-config.js /
copy be/config /config
copy be/lib /lib
copy be/mix.exs /
copy be/mix.lock /
copy be/package.json /

copy be/priv/repo /priv/repo
copy be/priv/gettext /priv/gettext

copy be/test /test
copy be/web /web

ENV MIX_ENV=prod

COPY docker/prod.secret.exs config/prod.secret.exs

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install


COPY fe/dist /priv/static/ui

RUN brunch build \
    && env MIX_ENV=prod mix clean \
    && env MIX_ENV=prod mix phoenix.digest \
    && env MIX_ENV=prod mix compile



COPY docker/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
