defmodule OrgtoolDb.Repo.Migrations.AddMemberFieldToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :member_id, references(:members)
    end
  end
end
