defmodule OrgtoolDb.CategoryView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img]
end
