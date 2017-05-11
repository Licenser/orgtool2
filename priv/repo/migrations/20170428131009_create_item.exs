defmodule OrgtoolDb.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :text
      add :img, :string
      add :hidden, :boolean, default: false, null: false
      add :available, :boolean, default: false, null: false

      add :player_id, references(:players)
      add :item_id, references(:items)
      add :item_type_id, references(:item_types)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
