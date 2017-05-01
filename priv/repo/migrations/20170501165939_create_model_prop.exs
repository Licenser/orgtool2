defmodule OrgtoolDb.Repo.Migrations.CreateTemplateProp do
  use Ecto.Migration

  def change do
    create table(:template_props) do
      add :name, :string
      add :value, :string
      add :template_id, references(:templates)

      timestamps()
    end

  end
end
