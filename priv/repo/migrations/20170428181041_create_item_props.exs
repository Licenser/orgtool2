defmodule OrgtoolDb.Repo.Migrations.CreateItemProps do
  use Ecto.Migration

  def change do
    create table(:item_props) do
      add :item_id, :integer
      add :prop_id, :integer

      timestamps()
    end

  end
end
