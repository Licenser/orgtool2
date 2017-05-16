defmodule OrgtoolDb.Item do
  use OrgtoolDb.Web, :template

  schema "items" do
    field :available, :boolean, default: false
    field :description, :string
    field :hidden, :boolean, default: false
    field :img, :string
    field :name, :string

    belongs_to :player, OrgtoolDb.Player
    belongs_to :unit, OrgtoolDb.Unit
    belongs_to :template, OrgtoolDb.Template

    has_many :item_props, OrgtoolDb.ItemProp

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:available, :description, :hidden, :img, :name])
    |> cast_assoc(:template)
    |> cast_assoc(:player)
    |> cast_assoc(:unit)
    |> cast_assoc(:item_props)
    |> validate_required([:available, :hidden, :img, :name])
  end
end
