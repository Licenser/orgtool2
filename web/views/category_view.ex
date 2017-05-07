defmodule OrgtoolDb.CategoryView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img]

  has_many :templates,
    serializer: OrgtoolDb.TemplateView,
    include: false,
    identifiers: :always
end
