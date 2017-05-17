defmodule OrgtoolDb.Repo.Migrations.AddUserUnfoldLevel do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :unfold_level, :integer, default: 1
    end
  end
end
