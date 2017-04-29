defmodule OrgtoolDb.RewardType do
  use OrgtoolDb.Web, :model

  schema "reward_types" do
    field :name, :string
    field :description, :string
    field :img, :string
    field :level, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :img, :level])
    |> validate_required([:name, :description, :img, :level])
  end
end
