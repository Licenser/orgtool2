defmodule OrgtoolDb.PermissionView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :member_read, :member_create, :member_edit, :member_delete,

    :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,

    :item_read, :item_create, :item_edit, :item_delete,

    :reward_read, :reward_create, :reward_edit, :reward_delete,
  ]

  has_one :user,
    serializer: OrgtoolDb.UserView,
    include: false,
    identifiers: :when_included
end
