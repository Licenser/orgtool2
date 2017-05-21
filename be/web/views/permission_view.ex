defmodule OrgtoolDb.PermissionView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [
    :active,
    :user_read, :user_create, :user_edit, :user_delete,
    :player_read, :player_create, :player_edit, :player_delete,
    :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,
    :ship_model_read, :ship_model_create, :ship_model_edit, :ship_model_delete,
    :ship_read, :ship_create, :ship_edit, :ship_delete,
    :reward_read, :reward_create, :reward_edit, :reward_delete
  ]

  has_one :user,
    serializer: OrgtoolDb.UserApiView,
    include: false,
    identifiers: :when_included
end
