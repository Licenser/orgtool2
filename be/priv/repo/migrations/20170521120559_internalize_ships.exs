defmodule OrgtoolDb.Repo.Migrations.InternalizeShips do
  use Ecto.Migration

  def change do
    alter table(:templates) do
      remove :category_id
      add :manufacturer, :string
      add :ship_id, :integer, unique: true
      add :class, :string
      add :length, :float
      add :crew, :integer
      add :mass, :float
    end

    execute """
    UPDATE templates
    SET ship_id = props.value
    FROM (SELECT template_id, value::int FROM template_props
    WHERE template_props.name = 'ship_id') AS props
    WHERE props.template_id = templates.id;
    """

    drop table(:categorys)
    drop table(:template_props)
  end
end
