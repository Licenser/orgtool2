defmodule OrgtoolDb.ModelProp do
  use OrgtoolDb.Web, :model

  schema "model_props" do
    field :name, :string
    field :value, :string
    field :model_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value, :model_id])
    |> validate_required([:name, :value, :model_id])
  end
end
