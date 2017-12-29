defmodule OrgtoolDb.HandleView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :handle, :img, :login, :typename]

  has_one :player,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included
end
