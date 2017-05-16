defmodule OrgtoolDb.ItemProp do
  use OrgtoolDb.Web, :template

  schema "item_props" do
    field :name, :string
    field :value, :string

    belongs_to :item, OrgtoolDb.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value])
    |> cast_assoc(:item)
    |> validate_required([:name, :value])
  end
end
