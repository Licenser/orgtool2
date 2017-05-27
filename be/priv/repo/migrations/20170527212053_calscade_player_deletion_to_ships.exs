defmodule OrgtoolDb.Repo.Migrations.CalscadePlayerDeletionToShips do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE ships DROP CONSTRAINT IF EXISTS items_player_id_fkey"
    execute "ALTER TABLE ships DROP CONSTRAINT IF EXISTS ships_player_id_fkey"
    alter table(:ships) do
      modify :player_id, references(:players, type: :integer, on_delete: :delete_all)
    end
  end
end
