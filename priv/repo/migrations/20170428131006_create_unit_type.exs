defmodule OrgtoolDb.Repo.Migrations.CreateUnitType do
  use Ecto.Migration

  def change do
    create table(:unit_types) do
      add :name, :string
      add :description, :text
      add :img, :string
      add :ordering, :integer

      timestamps()
    end

  end
end
