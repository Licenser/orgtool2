FROM elixir

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs

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

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install

# RUN cd priv/orgtool \
#     && npm install \
#     && yarn --allow-root \
#     && find /priv/orgtool/node_modules/bootstrap-sass \
#     && node_modules/ember-cli/bin/ember build --prod

COPY docker/prod.secret.exs config/prod.secret.exs

RUN env MIX_ENV=prod mix compile \
    && env MIX_ENV=prod mix phoenix.digest

copy priv/orgtool/dist /priv/static/ui


COPY docker/docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
