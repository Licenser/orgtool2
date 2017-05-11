defmodule OrgtoolDb.Repo.Migrations.AddPlayerFieldToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :player_id, references(:players)
    end
  end
end
