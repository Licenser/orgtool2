defmodule OrgtoolDb.PropView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{props: props}) do
    %{props: render_many(props, OrgtoolDb.PropView, "prop.json")}
  end

  def render("show.json", %{prop: prop}) do
    %{prop: render_one(prop, OrgtoolDb.PropView, "prop.json")}
  end

  def render("prop.json", %{prop: prop}) do
    %{id: prop.id,
      name: prop.name,
      value: prop.value,
      description: prop.description,
      img: prop.img,
      item: prop.item_id,
      type: prop.type_id,
      unit: prop.unit_id}
  end
end
