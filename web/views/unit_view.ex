defmodule OrgtoolDb.UnitView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView # Or use in web/web.ex

  attributes [:name, :description, :color, :img]

  has_many :units,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :always

  has_many :members,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_many :leaders,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_many :applicants,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_one :unit,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :always

  has_one :unit_type,
    serializer: OrgtoolDb.UnitTypeView,
    include: false,
    identifiers: :when_included
end
