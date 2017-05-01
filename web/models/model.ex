defmodule OrgtoolDb.Model do
  use OrgtoolDb.Web, :model

  schema "models" do
    field :name, :string
    field :img, :string
    field :description, :string

    belongs_to :category, OrgtoolDb.Category

    has_many :model_props, OrgtoolDb.ModelProp
    has_many :props, OrgtoolDb.Prop

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :img, :description, :category_id])
    |> validate_required([:name, :img, :category_id])
  end
end
