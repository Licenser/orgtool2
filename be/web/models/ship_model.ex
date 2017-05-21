defmodule OrgtoolDb.ShipModel do
  use OrgtoolDb.Web, :template

  schema "ship_models" do
    field :name, :string
    field :img, :string
    field :description, :string

    field :manufacturer, :string
    field :ship_id, :integer
    field :class, :string
    field :length, :float
    field :crew, :integer
    field :mass, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :img, :description, :manufacturer, :ship_id, :class, :length, :crew, :mass])
    |> validate_required([:name, :img, :ship_id])
  end
end
