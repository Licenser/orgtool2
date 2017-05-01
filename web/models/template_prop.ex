defmodule OrgtoolDb.TemplateProp do
  use OrgtoolDb.Web, :template

  schema "template_props" do
    field :name, :string
    field :value, :string
    field :template_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value, :template_id])
    |> validate_required([:name, :value, :template_id])
  end
end
