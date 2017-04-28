defmodule OrgtoolDb.Prop do
  use OrgtoolDb.Web, :model

  schema "props" do
    field :name, :string
    field :value, :string
    field :description, :string
    field :img, :string

    belongs_to :units, OrgtoolDb.Unit, foreign_key: :unit
    belongs_to :items, OrgtoolDb.Item, foreign_key: :item
    belongs_to :types, OrgtoolDb.Type, foreign_key: :type

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :value, :description, :img, :item, :type, :unit])
    |> validate_required([:name, :value, :description, :img, :item, :type, :unit])
  end
end
