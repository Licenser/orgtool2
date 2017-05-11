defmodule OrgtoolDb.ItemView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:available, :description, :hidden, :img, :name]

  has_one :player,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included

  has_one :template,
    serializer: OrgtoolDb.TemplateView,
    include: false,
    identifiers: :when_included

  has_one :unit,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  has_many :item_props,
    serializer: OrgtoolDb.ItemProp,
    include: false,
    identifiers: :when_included

end
