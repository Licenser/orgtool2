defmodule OrgtoolDb.Unit do
  use OrgtoolDb.Web, :template

  schema "units" do
    field :name, :string
    field :description, :string
    field :color, :string
    field :img, :string

    belongs_to :unit_type, OrgtoolDb.UnitType
    belongs_to :unit, OrgtoolDb.Unit
    has_many :units, OrgtoolDb.Unit

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :color, :img, :unit_type_id, :unit_id])
    #|> validate_required([:name, :description, :color, :img, :unit_type_id, :unit_id])
    |> validate_required([:unit_type_id, :unit_id])
  end
end
