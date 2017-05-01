defmodule OrgtoolDb.ManufacturerView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{manufacturers: manufacturers}) do
    %{manufacturers: render_many(manufacturers, OrgtoolDb.ManufacturerView, "manufacturer.json")}
  end

  def render("show.json", %{manufacturer: manufacturer}) do
    %{manufacturer: render_one(manufacturer, OrgtoolDb.ManufacturerView, "manufacturer.json")}
  end

  def render("manufacturer.json", %{manufacturer: manufacturer}) do
    %{id: manufacturer.id,
      name: manufacturer.name,
      img: manufacturer.img}
  end
end
