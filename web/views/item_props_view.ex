defmodule OrgtoolDb.ItemPropsView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{item_props: item_props}) do
    %{item_props: render_many(item_props, OrgtoolDb.ItemPropsView, "item_props.json")}
  end

  def render("show.json", %{item_props: item_props}) do
    %{item_prop: render_one(item_props, OrgtoolDb.ItemPropsView, "item_props.json")}
  end

  def render("item_props.json", %{item_props: item_props}) do
    %{id: item_props.id,
      item: item_props.item,
      prop: item_props.prop}
  end
end
