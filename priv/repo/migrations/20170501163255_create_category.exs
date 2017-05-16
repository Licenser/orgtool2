defmodule OrgtoolDb.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categorys) do
      add :name, :string
      add :img, :string

      timestamps()
    end

  end
end
