mix ecto.drop
mix ecto.create && \
  mix ecto.migrate && \
  mix run priv/repo/item_types.exs && \
  mix run priv/repo/unit_types.exs && \
  mix run priv/repo/seeds.exs
