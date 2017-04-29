defmodule OrgtoolDb.ItemProps do
  use OrgtoolDb.Web, :model

  schema "item_props" do

    belongs_to :item, OrgtoolDb.Item
    belongs_to :prop, OrgtoolDb.Prop


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:item_id, :prop_id])
    |> validate_required([:item_id, :prop_id])
  end
end
