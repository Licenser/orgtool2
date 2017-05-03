defmodule OrgtoolDb.TemplateView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img, :description]

  has_one :category,
    serializer: OrgtoolDb.CategoryView,
    include: false,
    identifiers: :when_included

  has_one :template_props,
    serializer: OrgtoolDb.TemplatePropView,
    include: false,
    identifiers: :when_included
end
