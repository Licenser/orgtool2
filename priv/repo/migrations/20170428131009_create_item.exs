defmodule OrgtoolDb.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :available, :boolean, default: false, null: false
      add :description, :text
      add :hidden, :boolean, default: false, null: false
      add :img, :string
      add :member, :integer
      add :name, :string
      add :parent, :integer
      add :type, :integer
      add :unit, :integer

      timestamps()
    end

  end
end
