defmodule OrgtoolDb.MemberUnits do
  use OrgtoolDb.Web, :model

  schema "member_units" do

    belongs_to :member, OrgtoolDb.Member
    belongs_to :unit, OrgtoolDb.Unit
    belongs_to :reward, OrgtoolDb.Reward

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:log, :member_id, :reward_id, :unit_id])
    |> validate_required([:log, :member_id, :reward_id, :unit_id])
  end
end
