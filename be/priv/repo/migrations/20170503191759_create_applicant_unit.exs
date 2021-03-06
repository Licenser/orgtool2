defmodule OrgtoolDb.Repo.Migrations.CreateApplicantUnit do
  use Ecto.Migration

  def change do
    create table(:applicant_units) do
      add :player_id, references(:players)
      add :unit_id, references(:units)

      timestamps()
    end

  end
end
