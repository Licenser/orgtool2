defmodule OrgtoolDb.Handle do
  use OrgtoolDb.Web, :template

  schema "handles" do
    field :name, :string
    field :handle, :string
    field :img, :string
    field :login, :string
    field :typename, :string

    belongs_to :player, OrgtoolDb.Player

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :handle, :img, :login, :typename])
    |> cast_assoc(:player)
    |> validate_required([:name, :handle])
  end
end
