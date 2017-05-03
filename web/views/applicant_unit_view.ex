defmodule OrgtoolDb.ApplicantUnitView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes []

  has_one :member,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_one :unit,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

end
