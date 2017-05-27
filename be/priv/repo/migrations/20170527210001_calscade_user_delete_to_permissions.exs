defmodule OrgtoolDb.Repo.Migrations.CalscadeUserDeleteToPermissions do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE permissions DROP CONSTRAINT permissions_user_id_fkey"
    alter table(:permissions) do
      modify :user_id, references(:users, type: :integer, on_delete: :delete_all)
    end

  end
end
