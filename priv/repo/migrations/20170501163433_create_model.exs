defmodule OrgtoolDb.Repo.Migrations.CreateModel do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :name, :string
      add :img, :string
      add :description, :text
      add :category_id, references(:categorys)

      timestamps()
    end

  end
end
