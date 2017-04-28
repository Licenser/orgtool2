defmodule OrgtoolDb.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string
      add :avatar, :string
      add :logs, :text
      add :timezone, :integer

      timestamps()
    end

  end
end
