defmodule OrgtoolDb.Repo.Migrations.CreateUnit do
  use Ecto.Migration

  def change do
    create table(:units) do
      add :name, :string
      add :description, :text
      add :color, :string
      add :img, :string
      add :type, :integer
      add :parent, :integer

      timestamps()
    end

  end
end
