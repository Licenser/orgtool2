defmodule OrgtoolDb.Item do
  use OrgtoolDb.Web, :model

  schema "items" do
    field :available, :boolean, default: false
    field :description, :string
    field :hidden, :boolean, default: false
    field :img, :string
    field :member, :integer
    field :name, :string
    field :unit, :integer

    belongs_to :item, OrgtoolDb.Item, foreign_key: :parent
    belongs_to :item_types, OrgtoolDb.ItemType, foreign_key: :type
    has_many :items, OrgtoolDb.Item, foreign_key: :parent

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:available, :description, :hidden, :img, :member, :name, :parent, :type, :unit])
    |> validate_required([:available, :description, :hidden, :img, :member, :name, :parent, :type, :unit])
  end
end
