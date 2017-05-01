defmodule OrgtoolDb.MemberReward do
  use OrgtoolDb.Web, :template

  schema "member_rewards" do

    belongs_to :member, OrgtoolDb.Member
    belongs_to :reward, OrgtoolDb.Reward

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:reward_id, :member_id])
    |> validate_required([:reward_id, :member_id])
  end
end
