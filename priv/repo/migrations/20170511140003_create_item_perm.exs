defmodule OrgtoolDb.Repo.Migrations.CreateItemPerm do
  use Ecto.Migration

  def change do
    create table(:item_perms) do
      add :user_id, references(:users)
      add :read, :boolean, default: false, null: false
      add :create, :boolean, default: false, null: false
      add :edit, :boolean, default: false, null: false
      add :delete, :boolean, default: false, null: false

      timestamps()
    end

  end
end
