defmodule OrgtoolDb.PropTypeView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{prop_types: prop_types}) do
    %{data: render_many(prop_types, OrgtoolDb.PropTypeView, "prop_type.json")}
  end

  def render("show.json", %{prop_type: prop_type}) do
    %{data: render_one(prop_type, OrgtoolDb.PropTypeView, "prop_type.json")}
  end

  def render("prop_type.json", %{prop_type: prop_type}) do
    %{id: prop_type.id,
      name: prop_type.name,
      type_name: prop_type.type_name,
      img: prop_type.img,
      description: prop_type.description}
  end
end
