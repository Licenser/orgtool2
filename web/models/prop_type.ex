defmodule OrgtoolDb.PropType do
  use OrgtoolDb.Web, :template

  schema "prop_types" do
    field :name, :string
    field :type_name, :string
    field :img, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :type_name, :img, :description])
    |> validate_required([:name, :type_name, :img, :description])
  end
end
