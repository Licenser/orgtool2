defmodule OrgtoolDb.Repo.Migrations.CalscadePlayerDeletion do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE player_units DROP CONSTRAINT player_units_player_id_fkey"
    execute "ALTER TABLE player_units DROP CONSTRAINT player_units_unit_id_fkey"
    alter table(:player_units) do
      modify :player_id, references(:players, type: :integer, on_delete: :delete_all)
      modify :unit_id, references(:units, type: :integer, on_delete: :delete_all)
    end

    execute "ALTER TABLE applicant_units DROP CONSTRAINT applicant_units_player_id_fkey"
    execute "ALTER TABLE applicant_units DROP CONSTRAINT applicant_units_unit_id_fkey"
    alter table(:applicant_units) do
      modify :player_id, references(:players, type: :integer, on_delete: :delete_all)
      modify :unit_id, references(:units, type: :integer, on_delete: :delete_all)
    end

    execute "ALTER TABLE leader_units DROP CONSTRAINT leader_units_player_id_fkey"
    execute "ALTER TABLE leader_units DROP CONSTRAINT leader_units_unit_id_fkey"
    alter table(:leader_units) do
      modify :player_id, references(:players, type: :integer, on_delete: :delete_all)
      modify :unit_id, references(:units, type: :integer, on_delete: :delete_all)
    end
  end
end
