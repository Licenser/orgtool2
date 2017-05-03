defmodule OrgtoolDb.Repo.Migrations.CreateMemberUnits do
  use Ecto.Migration

  def change do
    create table(:member_units) do
      add :member_id, references(:members)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
