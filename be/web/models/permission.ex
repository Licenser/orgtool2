defmodule OrgtoolDb.Permission do
  use OrgtoolDb.Web, :template
  alias OrgtoolDb.Repo

  schema "permissions" do

    field :active,        :boolean, default: false

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

    field :ship_model_read,     :boolean, default: false
    field :ship_model_create,   :boolean, default: false
    field :ship_model_edit,     :boolean, default: false
    field :ship_model_delete,   :boolean, default: false

    field :ship_read,     :boolean, default: false
    field :ship_create,   :boolean, default: false
    field :ship_edit,     :boolean, default: false
    field :ship_delete,   :boolean, default: false

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
        active: true,
        user_read: true, user_create: true, user_edit: true, user_delete: true,
        player_read: true, player_create: true, player_edit: true, player_delete: true,
        unit_read: true, unit_create: true, unit_edit: true, unit_delete: true, unit_apply: true, unit_accept: true, unit_assign: true,
        ship_model_read: true, ship_model_create: true, ship_model_edit: true, ship_model_delete: true,
        ship_read: true, ship_create: true, ship_edit: true, ship_delete: true,
        reward_read: true, reward_create: true, reward_edit: true, reward_delete: true
      })
      |> Repo.update!
  end


  @permissions [
    :active,
    :user_read, :user_create, :user_edit, :user_delete,
    :player_read, :player_create, :player_edit, :player_delete,
    :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,
    :ship_model_read, :ship_model_create, :ship_model_edit, :ship_model_delete,
    :ship_read, :ship_create, :ship_edit, :ship_delete,
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
