defmodule OrgtoolDb.Item do
  use OrgtoolDb.Web, :model

  schema "items" do
    field :available, :boolean, default: false
    field :description, :string
    field :hidden, :boolean, default: false
    field :img, :string
    field :name, :string

    belongs_to :member, OrgtoolDb.Member
    belongs_to :unit, OrgtoolDb.Unit
    belongs_to :model, OrgtoolDb.Model

    has_many :props, OrgtoolDb.Prop

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:available, :description, :hidden, :img, :member_id, :name, :model_id, :unit_id])
    |> validate_required([:available, :hidden, :img, :name_id, :model_id])
  end
end
