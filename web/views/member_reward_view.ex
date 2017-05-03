defmodule OrgtoolDb.MemberRewardView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes []

  has_one :member,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_one :reward,
    serializer: OrgtoolDb.RewardView,
    include: false,
    identifiers: :when_included
end
