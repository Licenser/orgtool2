FROM elixir

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

RUN echo '{ "allow_root": true }' > /root/.bowerrc

RUN cd / \
    && env GIT_SSL_NO_VERIFY=true git clone https://github.com/Licenser/orgtool_db \
    && cd orgtool_db \
    && mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && npm install

RUN cd /orgtool_db \
    && env GIT_SSL_NO_VERIFY=true git submodule update --init \
    && cd priv/orgtool \
    && yarn --allow-root \
    && node_modules/ember-cli/bin/ember build --prod

COPY prod.secret.exs /orgtool_db/config/prod.secret.exs

RUN cd /orgtool_db \
    && env MIX_ENV=prod mix compile \
    && env MIX_ENV=prod mix phoenix.digest

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
