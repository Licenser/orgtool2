defmodule OrgtoolDb.UnitView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView # Or use in web/web.ex

  attributes [:name, :description, :color, :img]

  has_many :units,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  has_many :players,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included

  has_many :leaders,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included

  has_many :applicants,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included

  has_one :unit,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  has_one :items,
    serializer: OrgtoolDb.ItemView,
    include: false,
    identifiers: :when_included

  has_one :unit_type,
    serializer: OrgtoolDb.UnitTypeView,
    include: true,
    identifiers: :when_included
end
