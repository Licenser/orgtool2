defmodule OrgtoolDb.Repo.Migrations.CreatePlayerUnits do
  use Ecto.Migration

  def change do
    create table(:player_units) do
      add :player_id, references(:players)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
