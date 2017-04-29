defmodule OrgtoolDb.Repo.Migrations.CreateMemberReward do
  use Ecto.Migration

  def change do
    create table(:member_rewards) do
      add :reward_id, :integer
      add :member_id, :integer

      timestamps()
    end

  end
end
