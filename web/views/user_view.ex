defmodule OrgtoolDb.UserView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :name]

  has_one :permissionission,
    serializer: OrgtoolDb.PermissionView,
    include: false,
    identifiers: :when_included
end
