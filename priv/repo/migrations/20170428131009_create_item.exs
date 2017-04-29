defmodule OrgtoolDb.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :description, :text
      add :img, :string
      add :hidden, :boolean, default: false, null: false
      add :available, :boolean, default: false, null: false

      add :member_id, :integer
      add :item_id, :integer
      add :item_type_id, :integer
      add :unit_id, :integer

      timestamps()
    end

  end
end
