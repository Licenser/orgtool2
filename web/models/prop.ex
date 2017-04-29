defmodule OrgtoolDb.Prop do
  use OrgtoolDb.Web, :model

  schema "props" do
    field :name, :string
    field :value, :string
    field :description, :string
    field :img, :string

    belongs_to :item, OrgtoolDb.Item
    belongs_to :prop_type, OrgtoolDb.PropType

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value, :description, :img, :item_id, :prop_type_id, :unit_id])
    |> validate_required([:name, :value, :description, :img, :item_id, :prop_type_id, :unit_id])
  end
end
