defmodule OrgtoolDb.Repo.Migrations.CreateMemberUnits do
  use Ecto.Migration

  def change do
    create table(:member_units) do
      add :member_id, :integer
      add :reward_id, :integer
      add :unit_id, :integer

      timestamps()
    end

  end
end
