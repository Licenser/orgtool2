defmodule OrgtoolDb.Reward do
  use OrgtoolDb.Web, :model

  schema "rewards" do
    field :description, :string
    field :img, :string
    field :level, :integer
    field :name, :string

    belongs_to :reward_type, OrgtoolDb.RewardType

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :img, :level, :name, :reward_type])
    |> validate_required([:description, :img, :level, :name, :reward_type])
  end
end
