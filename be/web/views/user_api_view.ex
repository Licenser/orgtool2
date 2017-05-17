defmodule OrgtoolDb.UserApiView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  def type, do: "user"

  attributes [:email, :name, :unfold_level]

  has_one :permission,
    serializer: OrgtoolDb.PermissionView,
    include: false,
    identifiers: :when_included

  has_one :player,
    serializer: OrgtoolDb.PlayerView,
    include: false,
    identifiers: :when_included
end
