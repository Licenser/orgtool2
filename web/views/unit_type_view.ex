defmodule OrgtoolDb.UnitTypeView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView # Or use in web/web.ex

  attributes [:name, :description, :ordering, :img]

  has_many :units,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

end
