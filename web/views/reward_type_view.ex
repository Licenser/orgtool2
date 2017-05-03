defmodule OrgtoolDb.RewardTypeView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img, :description, :level]

  has_many :rewards,
    serializer: OrgtoolDb.RewardView,
    include: false,
    identifiers: :when_included

end
