defmodule OrgtoolDb.Repo.Migrations.CreateTemplate do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :img, :string
      add :description, :text
      add :category_id, references(:categorys)

      timestamps()
    end

  end
end
