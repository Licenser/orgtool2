defmodule OrgtoolDb.Repo.Migrations.CreateUnit do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string
      add :description, :text
      add :color, :string
      add :img, :string
      add :unit_type_id, references(:unit_types)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
