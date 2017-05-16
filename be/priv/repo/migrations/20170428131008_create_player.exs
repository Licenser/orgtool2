defmodule OrgtoolDb.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :avatar, :string
      add :logs, :text
      add :timezone, :integer

      timestamps()
    end

  end
end
