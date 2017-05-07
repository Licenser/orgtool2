defmodule OrgtoolDb.MemberView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :avatar, :timezone]

  has_many :items,
    serializer: OrgtoolDb.ItemView,
    include: false,
    identifiers: :always

  has_many :handles,
    serializer: OrgtoolDb.HandleView,
    include: false,
    identifiers: :when_included

  has_many :rewards,
    serializer: OrgtoolDb.RewardView,
    include: false,
    identifiers: :when_included


  has_many :leaderships,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  has_many :memberships,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  has_many :applications,
    serializer: OrgtoolDb.UnitView,
    include: false,
    identifiers: :when_included

  # has_one :user,
  #   serializer: OrgtoolDb.UserView,
  #   include: false,
  #   identifiers: :when_included
end
