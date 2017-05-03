defmodule OrgtoolDb.LeaderUnit do
  use OrgtoolDb.Web, :template

  schema "leader_units" do

    belongs_to :member, OrgtoolDb.Member
    belongs_to :unit, OrgtoolDb.Unit

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:member_id, :unit_id])
    |> validate_required([:member_id, :unit_id])
  end
end
