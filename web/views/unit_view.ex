defmodule OrgtoolDb.UnitView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{units: units}) do
    %{units: render_many(units, OrgtoolDb.UnitView, "unit.json")}
  end

  def render("show.json", %{unit: unit}) do
    %{unit: render_one(unit, OrgtoolDb.UnitView, "unit.json")}
  end

  def render("unit.json", %{unit: unit}) do
    %{id: unit.id,
      name: unit.name,
      description: unit.description,
      color: unit.color,
      img: unit.img,
      type: unit.unit_type_id,
      parent: unit.unit_id}
  end
end
