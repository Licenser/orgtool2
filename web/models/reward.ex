defmodule OrgtoolDb.Reward do
  use OrgtoolDb.Web, :template

  schema "rewards" do
    field :name, :string
    field :level, :integer
    field :description, :string
    field :img, :string

    belongs_to :reward_type, OrgtoolDb.RewardType, on_replace: :nilify
    many_to_many :players, OrgtoolDb.Player, join_through: OrgtoolDb.PlayerReward, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :img, :level, :name])
    |> cast_assoc(:reward_type)
    |> cast_assoc(:players)
    |> validate_required([:description, :level, :name])
  end
end
