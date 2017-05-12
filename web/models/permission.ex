defmodule OrgtoolDb.Permission do
  use OrgtoolDb.Web, :template

  schema "permissions" do


    field :member_read,   :boolean, default: false
    field :member_create, :boolean, default: false
    field :member_edit,   :boolean, default: false
    field :member_delete, :boolean, default: false

    field :unit_read,     :boolean, default: false
    field :unit_create,   :boolean, default: false
    field :unit_edit,     :boolean, default: false
    field :unit_delete,   :boolean, default: false
    field :unit_apply,    :boolean, default: false
    field :unit_accept,   :boolean, default: false
    field :unit_assign,   :boolean, default: false

    field :item_read,     :boolean, default: false
    field :item_create,   :boolean, default: false
    field :item_edit,     :boolean, default: false
    field :item_delete,   :boolean, default: false

    field :reward_read,   :boolean, default: false
    field :reward_create, :boolean, default: false
    field :reward_edit,   :boolean, default: false
    field :reward_delete, :boolean, default: false

    belongs_to :user, OrgtoolDb.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params,
    [
      :member_read, :member_create, :member_edit, :member_delete,

      :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,

      :item_read, :item_create, :item_edit, :item_delete,

      :reward_read, :reward_create, :reward_edit, :reward_delete
    ])
    |> cast_assoc(:user)
    |> validate_required(
      [
        :member_read, :member_create, :member_edit, :member_delete,

        :unit_read, :unit_create, :unit_edit, :unit_delete, :unit_apply, :unit_accept, :unit_assign,

        :item_read, :item_create, :item_edit, :item_delete,

        :reward_read, :reward_create, :reward_edit, :reward_delete
      ])
  end
end
