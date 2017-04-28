defmodule OrgtoolDb.Repo.Migrations.CreateItemType do
  use Ecto.Migration

  def change do
    create table(:item_types) do
      add :name, :string
      add :typeName, :string
      add :description, :text
      add :img, :string
      add :permissions, :integer

      timestamps()
    end

  end
end
