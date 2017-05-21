defmodule OrgtoolDb.ShipModelView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img, :description, :manufacturer, :ship_id, :class, :length, :crew, :mass]

end
