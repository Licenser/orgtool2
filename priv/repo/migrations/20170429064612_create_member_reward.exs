defmodule OrgtoolDb.Repo.Migrations.CreateMemberReward do
  use Ecto.Migration

  def change do
    create table(:member_rewards) do
      add :reward_id, references(:rewards)
      add :member_id, references(:members)

      timestamps()
    end

  end
end
