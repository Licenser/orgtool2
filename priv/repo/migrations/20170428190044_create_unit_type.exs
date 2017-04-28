defmodule OrgtoolDb.Repo.Migrations.CreateUnitType do
  use Ecto.Migration

  def change do
    create table(:unit_types) do
      add :description, :text
      add :img, :string
      add :name, :string
      add :ordering, :integer

      timestamps()
    end

  end
end
