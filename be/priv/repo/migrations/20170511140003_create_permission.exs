defmodule OrgtoolDb.Repo.Migrations.CreatePermission do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :user_id, references(:users)

      add :user_read,   :boolean, default: false, null: false
      add :user_create, :boolean, default: false, null: false
      add :user_edit,   :boolean, default: false, null: false
      add :user_delete, :boolean, default: false, null: false

      add :player_read,   :boolean, default: false, null: false
      add :player_create, :boolean, default: false, null: false
      add :player_edit,   :boolean, default: false, null: false
      add :player_delete, :boolean, default: false, null: false

      add :unit_read,     :boolean, default: false, null: false
      add :unit_create,   :boolean, default: false, null: false
      add :unit_edit,     :boolean, default: false, null: false
      add :unit_delete,   :boolean, default: false, null: false
      add :unit_apply,    :boolean, default: false, null: false
      add :unit_accept,   :boolean, default: false, null: false
      add :unit_assign,   :boolean, default: false, null: false

      add :category_read,     :boolean, default: false, null: false
      add :category_create,   :boolean, default: false, null: false
      add :category_edit,     :boolean, default: false, null: false
      add :category_delete,   :boolean, default: false, null: false

      add :template_read,     :boolean, default: false, null: false
      add :template_create,   :boolean, default: false, null: false
      add :template_edit,     :boolean, default: false, null: false
      add :template_delete,   :boolean, default: false, null: false

      add :item_read,     :boolean, default: false, null: false
      add :item_create,   :boolean, default: false, null: false
      add :item_edit,     :boolean, default: false, null: false
      add :item_delete,   :boolean, default: false, null: false

      add :reward_read,   :boolean, default: false, null: false
      add :reward_create, :boolean, default: false, null: false
      add :reward_edit,   :boolean, default: false, null: false
      add :reward_delete, :boolean, default: false, null: false

      timestamps()
    end

  end
end
