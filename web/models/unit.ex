defmodule OrgtoolDb.Unit do
  use OrgtoolDb.Web, :model

  schema "units" do
    field :name, :string
    field :description, :string
    field :color, :string
    field :img, :string

    belongs_to :unit_type, OrgtoolDb.UnitType, foreign_key: :type
    belongs_to :unit, OrgtoolDb.Unit, foreign_key: :parent
    has_many :units, OrgtoolDb.Unit, foreign_key: :parent

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :color, :img, :type, :parent])
    |> validate_required([:name, :description, :color, :img, :type, :parent])
  end
end
