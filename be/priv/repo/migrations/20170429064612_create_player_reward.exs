defmodule OrgtoolDb.Repo.Migrations.CreatePlayerReward do
  use Ecto.Migration

  def change do
    create table(:player_rewards) do
      add :reward_id, references(:rewards)
      add :player_id, references(:players)

      timestamps()
    end

  end
end
