defmodule OrgtoolDb.PlayerReward do
  use OrgtoolDb.Web, :template

  schema "player_rewards" do

    belongs_to :player, OrgtoolDb.Player
    belongs_to :reward, OrgtoolDb.Reward

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:reward_id, :player_id])
    |> validate_required([:reward_id, :player_id])
  end
end
