defmodule OrgtoolDb.Repo.Migrations.CreateMemberUnits do
  use Ecto.Migration

  def change do
    create table(:member_units) do
      add :log, :text
      add :member, :integer
      add :reward, :integer
      add :unit, :integer

      timestamps()
    end

  end
end
