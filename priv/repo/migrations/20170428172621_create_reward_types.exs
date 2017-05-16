defmodule OrgtoolDb.Repo.Migrations.CreateRewardTypes do
  use Ecto.Migration

  def change do
    create table(:reward_types) do
      add :name, :string
      add :description, :text
      add :img, :string
      add :level, :integer

      timestamps()
    end

  end
end
