defmodule OrgtoolDb.Repo.Migrations.CreatePropType do
  use Ecto.Migration

  def change do
    create table(:prop_types) do
      add :name, :string
      add :type_name, :string
      add :img, :string
      add :description, :text

      timestamps()
    end

  end
end
