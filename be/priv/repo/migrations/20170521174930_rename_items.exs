defmodule OrgtoolDb.Repo.Migrations.RenameItems do
  use Ecto.Migration

  def change do
    drop table(:item_props)
    rename table(:items), to: table(:ships)
    rename table(:templates), to: table(:ship_models)


    rename table(:ships), :template_id, to: :ship_model_id
    rename table(:permissions), :template_read, to: :ship_model_read
    rename table(:permissions), :template_create, to: :ship_model_create
    rename table(:permissions), :template_edit, to: :ship_model_edit
    rename table(:permissions), :template_delete, to: :ship_model_delete

    rename table(:permissions), :item_read, to: :ship_read
    rename table(:permissions), :item_create, to: :ship_create
    rename table(:permissions), :item_edit, to: :ship_edit
    rename table(:permissions), :item_delete, to: :ship_delete

    alter table(:permissions) do

      remove :category_read
      remove :category_create
      remove :category_edit
      remove :category_delete
    end
  end
end
