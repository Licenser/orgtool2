defmodule OrgtoolDb.Repo.Migrations.CreateReward do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :name, :string
      add :description, :text
      add :img, :string
      add :level, :integer
      add :reward_type_id, references(:reward_types)

      timestamps()
    end

  end
end
