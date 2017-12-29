defmodule OrgtoolDb.Repo.Migrations.RenameTypeInHandles do
  use Ecto.Migration

  def change do
    rename table(:handles), :type, to: :typename
  end
end
