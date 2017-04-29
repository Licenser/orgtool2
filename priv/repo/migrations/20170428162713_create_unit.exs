defmodule OrgtoolDb.Repo.Migrations.CreateUnit do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string
      add :description, :text
      add :color, :string
      add :img, :string
      add :unit_type_id, :integer
      add :unit_id, :integer

      timestamps()
    end

  end
end
