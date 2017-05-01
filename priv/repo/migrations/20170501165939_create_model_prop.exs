defmodule OrgtoolDb.Repo.Migrations.CreateModelProp do
  use Ecto.Migration

  def change do
    create table(:model_props) do
      add :name, :string
      add :value, :string
      add :model_id, references(:models)

      timestamps()
    end

  end
end
