defmodule OrgtoolDb.Repo.Migrations.CreateModel do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :name, :string
      add :img, :string
      add :description, :text
      add :manufacturer_id, references(:manufacturers)

      timestamps()
    end

  end
end
