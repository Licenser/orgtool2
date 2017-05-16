defmodule OrgtoolDb.Category do
  use OrgtoolDb.Web, :template

  schema "categorys" do
    field :name, :string
    field :img, :string

    has_many :templates, OrgtoolDb.Template

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :img])
    |> validate_required([:name, :img])
  end
end
