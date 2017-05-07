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

    many_to_many :members, OrgtoolDb.Member, join_through: OrgtoolDb.MemberUnit, on_replace: :delete
    many_to_many :applicants, OrgtoolDb.Member, join_through: OrgtoolDb.ApplicantUnit, on_replace: :delete
    many_to_many :leaders, OrgtoolDb.Member, join_through: OrgtoolDb.LeaderUnit, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :color, :img])
    |> cast_assoc(:unit)
    |> cast_assoc(:units)
    |> cast_assoc(:unit_type)
    |> cast_assoc(:members)
    |> cast_assoc(:applicants)
    |> cast_assoc(:leaders)
    |> validate_required([])
  end
end
