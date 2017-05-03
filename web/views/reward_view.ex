defmodule OrgtoolDb.RewardView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :level, :img, :description]

  has_many :members,
    serializer: OrgtoolDb.MemberView,
    include: false,
    identifiers: :when_included

  has_one :reward_type,
    serializer: OrgtoolDb.RewardTypeView,
    include: false,
    identifiers: :when_included
end
