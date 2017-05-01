defmodule OrgtoolDb.Manufacturer do
  use OrgtoolDb.Web, :model

  schema "manufacturers" do
    field :name, :string
    field :img, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :img])
    |> validate_required([:name, :img])
  end
end
