defmodule OrgtoolDb.Ship do
  use OrgtoolDb.Web, :template

  schema "ships" do
    field :available, :boolean, default: false
    field :description, :string
    field :hidden, :boolean, default: false
    field :img, :string
    field :name, :string

    belongs_to :player, OrgtoolDb.Player, on_replace: :nilify
    belongs_to :unit, OrgtoolDb.Unit, on_replace: :nilify
    belongs_to :ship_model, OrgtoolDb.ShipModel

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:available, :description, :hidden, :img, :name, :unit_id])
    |> cast_assoc(:ship_model)
    |> cast_assoc(:player)
    |> cast_assoc(:unit)
    |> validate_required([:available, :hidden, :img, :name])
  end
end
