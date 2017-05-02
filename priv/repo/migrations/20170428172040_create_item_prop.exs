defmodule OrgtoolDb.Repo.Migrations.CreateItemProp do
  use Ecto.Migration

  def change do
    create table(:item_props) do
      add :name, :string
      add :value, :string
      add :item_id, :integer

      timestamps()
    end

  end
end
