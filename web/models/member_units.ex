defmodule OrgtoolDb.MemberUnits do
  use OrgtoolDb.Web, :model

  schema "member_units" do
    field :log, :string
    field :member, :integer
    field :reward, :integer
    field :unit, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:log, :member, :reward, :unit])
    |> validate_required([:log, :member, :reward, :unit])
  end
end
