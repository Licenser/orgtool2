defmodule OrgtoolDb.Reward do
  use OrgtoolDb.Web, :template

  schema "rewards" do
    field :name, :string
    field :level, :integer
    field :description, :string
    field :img, :string

    belongs_to :reward_type, OrgtoolDb.RewardType

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :img, :level, :name, :reward_type_id])
    |> validate_required([:description, :img, :level, :name, :reward_type_id])
  end
end
