defmodule OrgtoolDb.TemplateProp do
  use OrgtoolDb.Web, :template

  schema "template_props" do
    field :name, :string
    field :value, :string

    belongs_to :template, OrgtoolDb.Template

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value])
    |> cast_assoc(:template)
    |> validate_required([:name, :value])
  end
end
