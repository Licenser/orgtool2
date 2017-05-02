defmodule OrgtoolDb.ItemPropView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{item_props: props}) do
    %{item_props: render_many(props, OrgtoolDb.ItemPropView, "item_prop.json")}
  end

  def render("show.json", %{item_prop: prop}) do
    %{item_prop: render_one(prop, OrgtoolDb.ItemPropView, "item_prop.json")}
  end

  def render("item_prop.json", %{item_prop: prop}) do
    %{
      id: prop.id,
      name: prop.name,
      value: prop.value,
      item_id: prop.item_id
    }
  end
end
