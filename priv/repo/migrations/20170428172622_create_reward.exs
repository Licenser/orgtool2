defmodule OrgtoolDb.Repo.Migrations.CreateReward do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :description, :text
      add :img, :string
      add :level, :integer
      add :name, :string
      add :type, :integer

      timestamps()
    end

  end
end
