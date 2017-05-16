defmodule OrgtoolDb.PlayerUnit do
  use OrgtoolDb.Web, :template

  schema "player_units" do

    belongs_to :player, OrgtoolDb.Player
    belongs_to :unit, OrgtoolDb.Unit

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:player_id, :unit_id])
    |> validate_required([:player_id, :unit_id])
  end
end
