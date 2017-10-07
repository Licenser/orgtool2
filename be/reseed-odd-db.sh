mix ecto.drop
mix ecto.create && \
mix ecto.migrate && \
mix run priv/repo/rewards.exs && \
mix run priv/repo/oddysee_units.exs && \
mix run priv/repo/ships.exs
