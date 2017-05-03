defmodule OrgtoolDb.HandleView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :handle, :img, :login]

  has_one :member,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included
end
