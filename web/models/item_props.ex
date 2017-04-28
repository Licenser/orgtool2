defmodule OrgtoolDb.ItemProps do
  use OrgtoolDb.Web, :model

  schema "item_props" do
    field :item, :integer
    field :prop, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:item, :prop])
    |> validate_required([:item, :prop])
  end
end
