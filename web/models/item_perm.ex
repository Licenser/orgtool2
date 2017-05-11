defmodule OrgtoolDb.ItemPerm do
  use OrgtoolDb.Web, :template

  schema "item_perms" do

    field :read, :boolean, default: false
    field :create, :boolean, default: false
    field :edit, :boolean, default: false
    field :delete, :boolean, default: false

    belongs_to :user, OrgtoolDb.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:read, :create, :edit, :delete])
    |> cast_assoc(:user)
    |> validate_required([:read, :create, :edit, :delete])
  end
end
