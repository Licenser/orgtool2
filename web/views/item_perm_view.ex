defmodule OrgtoolDb.ItemPermView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:read, :create, :edit, :delete]

  has_one :user,
    serializer: OrgtoolDb.UserView,
    include: false,
    identifiers: :when_included
end
