defmodule OrgtoolDb.Repo.Migrations.CreateItemProps do
  use Ecto.Migration

  def change do
    create table(:item_props) do
      add :item, :integer
      add :prop, :integer

      timestamps()
    end

  end
end
