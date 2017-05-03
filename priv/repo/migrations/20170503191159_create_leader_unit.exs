defmodule OrgtoolDb.Repo.Migrations.CreateLeaderUnit do
  use Ecto.Migration

  def change do
    create table(:leader_units) do
      add :member_id, references(:members)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
