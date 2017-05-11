defmodule OrgtoolDb.UserView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :name]

  has_one :item_permission,
    serializer: OrgtoolDb.ItemPermView,
    include: false,
    identifiers: :when_included
end
