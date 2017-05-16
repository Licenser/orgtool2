defmodule OrgtoolDb.Repo.Migrations.AddActivePerm do
  use Ecto.Migration

  def up do
    alter table(:permissions) do
      add :active, :boolean, default: false, null: false
    end
  end

  def down do
    alter table(:permissions) do
      remove :active
    end
  end
end
