defmodule OrgtoolDb.Reward do
  use OrgtoolDb.Web, :model

  schema "rewards" do
    field :description, :string
    field :img, :string
    field :level, :integer
    field :name, :string
    field :type, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :img, :level, :name, :type])
    |> validate_required([:description, :img, :level, :name, :type])
  end
end
