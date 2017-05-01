defmodule OrgtoolDb.Repo.Migrations.CreateManufacturer do
  use Ecto.Migration

  def change do
    create table(:manufacturers) do
      add :name, :string
      add :img, :string

      timestamps()
    end

  end
end
