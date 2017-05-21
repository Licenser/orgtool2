defmodule OrgtoolDb.ShipView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:available, :description, :hidden, :img, :name]

  has_one :player,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included

  has_one :ship_model,
    serializer: OrgtoolDb.ShipModelView,
    include: false,
    identifiers: :when_included

  has_one :unit,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

end
