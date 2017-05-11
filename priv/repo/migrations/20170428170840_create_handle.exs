defmodule OrgtoolDb.Repo.Migrations.CreateHandle do
  use Ecto.Migration

  def change do
    create table(:handles) do
      add :name, :string
      add :handle, :string
      add :img, :string
      add :login, :string
      add :type, :string
      add :player_id, references(:players)

      timestamps()
    end

  end
end
