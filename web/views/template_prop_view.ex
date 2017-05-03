defmodule OrgtoolDb.TemplatePropView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :value]

  has_one :template,
    serializer: OrgtoolDb.TemplateView,
    include: false,
    identifiers: :when_included
end
