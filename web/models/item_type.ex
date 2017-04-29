defmodule OrgtoolDb.ItemType do
  use OrgtoolDb.Web, :model

  schema "item_types" do
    field :name, :string
    field :type_name, :string
    field :description, :string
    field :img, :string
    field :permissions, :integer

    belongs_to :item_type, OrgtoolDb.ItemType
    has_many :item_types, OrgtoolDb.ItemType
    has_many :items, OrgtoolDb.Item

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :typeName, :description, :img, :permissions, :item_type])
    |> validate_required([:name, :typeName, :description, :img, :permissions])
  end
end
