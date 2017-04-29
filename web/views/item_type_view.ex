defmodule OrgtoolDb.ItemTypeView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{item_types: item_types}) do
    %{item_types: render_many(item_types, OrgtoolDb.ItemTypeView, "item_type.json")}
  end

  def render("show.json", %{item_type: item_type}) do
    %{item_types: render_one(item_type, OrgtoolDb.ItemTypeView, "item_type.json")}
  end

  def render("item_type.json", %{item_type: item_type}) do
    items = if item_type.items == nil do
      []
    else
      for i <- item_type.items, do: i.id
    end

    %{
      id: item_type.id,
      name: item_type.name,
      typeName: item_type.type_name,
      description: item_type.description,
      img: item_type.img,
      permissions: item_type.permissions,
      items: items
    }
  end
end
