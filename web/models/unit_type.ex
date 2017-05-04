defmodule OrgtoolDb.UnitType do
  use OrgtoolDb.Web, :template

  schema "unit_types" do
    field :description, :string
    field :img, :string
    field :name, :string
    field :ordering, :integer

    has_many :units, OrgtoolDb.Unit
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :img, :name, :ordering])
    |> validate_required([:description, :img, :name, :ordering])
  end
end
