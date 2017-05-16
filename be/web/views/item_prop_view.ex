defmodule OrgtoolDb.ItemPropView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :value]

  has_one :item,
    serializer: OrgtoolDb.ItemView,
    include: false,
    identifiers: :when_included
end
