defmodule OrgtoolDb.PermissionView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [
      :user_read, :user_create, :user_edit, :user_delete,

      :player_read, :player_create, :player_edit, :player_delete,

      :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,

      :category_read, :category_create, :category_edit, :category_delete,

      :template_read, :template_create, :template_edit, :template_delete,

      :item_read, :item_create, :item_edit, :item_delete,

      :reward_read, :reward_create, :reward_edit, :reward_delete
  ]

  has_one :user,
    serializer: OrgtoolDb.UserApiView,
    include: false,
    identifiers: :when_included
end
