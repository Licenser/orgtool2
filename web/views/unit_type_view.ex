defmodule OrgtoolDb.UnitTypeView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{unit_types: unit_types}) do
    %{unit_types: render_many(unit_types, OrgtoolDb.UnitTypeView, "unit_type.json")}
  end

  def render("show.json", %{unit_type: unit_type}) do
    %{unit_type: render_one(unit_type, OrgtoolDb.UnitTypeView, "unit_type.json")}
  end

  def render("unit_type.json", %{unit_type: unit_type}) do
    %{id: unit_type.id,
      description: unit_type.description,
      img: unit_type.img,
      name: unit_type.name,
      ordering: unit_type.ordering}
  end
end
