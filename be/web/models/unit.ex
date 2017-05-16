defmodule OrgtoolDb.Unit do
  use OrgtoolDb.Web, :template

  schema "units" do
    field :name, :string
    field :description, :string
    field :color, :string
    field :img, :string

    belongs_to :unit_type, OrgtoolDb.UnitType, on_replace: :nilify
    belongs_to :unit, OrgtoolDb.Unit
    has_many :units, OrgtoolDb.Unit
    has_many :items, OrgtoolDb.Item

    many_to_many :players, OrgtoolDb.Player, join_through: OrgtoolDb.PlayerUnit, on_replace: :delete
    many_to_many :applicants, OrgtoolDb.Player, join_through: OrgtoolDb.ApplicantUnit, on_replace: :delete
    many_to_many :leaders, OrgtoolDb.Player, join_through: OrgtoolDb.LeaderUnit, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :color, :img])
    |> cast_assoc(:unit)
    |> cast_assoc(:items)
    |> cast_assoc(:unit_type)
    |> cast_assoc(:players)
    |> cast_assoc(:applicants)
    |> cast_assoc(:leaders)
    |> validate_required([])
  end
end
