defmodule OrgtoolDb.Repo.Migrations.AddModelPropToModels do
  use Ecto.Migration

  def change do
    alter table(:models) do
      add :_id, references(:models)
    end

  end
end
