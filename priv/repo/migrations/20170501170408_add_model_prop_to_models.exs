defmodule OrgtoolDb.Repo.Migrations.AddTemplatePropToTemplates do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      add :_id, references(:templates)
    end

  end
end
