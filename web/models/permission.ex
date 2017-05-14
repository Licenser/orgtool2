defmodule OrgtoolDb.Permission do
  use OrgtoolDb.Web, :template
  alias OrgtoolDb.Repo

  schema "permissions" do

    field :user_read,     :boolean, default: false
    field :user_create,   :boolean, default: false
    field :user_edit,     :boolean, default: false
    field :user_delete,   :boolean, default: false

    field :player_read,   :boolean, default: false
    field :player_create, :boolean, default: false
    field :player_edit,   :boolean, default: false
    field :player_delete, :boolean, default: false

    field :unit_read,     :boolean, default: false
    field :unit_create,   :boolean, default: false
    field :unit_edit,     :boolean, default: false
    field :unit_delete,   :boolean, default: false
    field :unit_apply,    :boolean, default: false
    field :unit_accept,   :boolean, default: false
    field :unit_assign,   :boolean, default: false

    field :category_read,     :boolean, default: false
    field :category_create,   :boolean, default: false
    field :category_edit,     :boolean, default: false
    field :category_delete,   :boolean, default: false

    field :template_read,     :boolean, default: false
    field :template_create,   :boolean, default: false
    field :template_edit,     :boolean, default: false
    field :template_delete,   :boolean, default: false

    field :item_read,     :boolean, default: false
    field :item_create,   :boolean, default: false
    field :item_edit,     :boolean, default: false
    field :item_delete,   :boolean, default: false

    field :reward_read,   :boolean, default: false
    field :reward_create, :boolean, default: false
    field :reward_edit,   :boolean, default: false
    field :reward_delete, :boolean, default: false

    belongs_to :user, OrgtoolDb.User

    timestamps()
  end

  def preload do
    [:user]
  end

  def all!(permission) do
    permission
    |> Repo.preload(:user)
    |> changeset(
      %{
        user_read: true, user_create: true, user_edit: true, user_delete: true,
        player_read: true, player_create: true, player_edit: true, player_delete: true,
        unit_read: true, unit_create: true, unit_edit: true, unit_delete: true, unit_apply: true, unit_accept: true, unit_assign: true,
        category_read: true, category_create: true, category_edit: true, category_delete: true,
        template_read: true, template_create: true, template_edit: true, template_delete: true,
        item_read: true, item_create: true, item_edit: true, item_delete: true,
        reward_read: true, reward_create: true, reward_edit: true, reward_delete: true
      })
      |> Repo.update!
  end


  @permissions [
    :user_read, :user_create, :user_edit, :user_delete,
    :player_read, :player_create, :player_edit, :player_delete,
    :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,
    :category_read, :category_create, :category_edit, :category_delete,
    :template_read, :template_create, :template_edit, :template_delete,
    :item_read, :item_create, :item_edit, :item_delete,
    :reward_read, :reward_create, :reward_edit, :reward_delete]
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permissions)
    |> cast_assoc(:user)
    |> validate_required(@permissions)
  end

  def changeset_include(struct, params \\ %{}) do
    struct
    |> cast(params, @permissions)
    |> validate_required(@permissions)
  end
end
