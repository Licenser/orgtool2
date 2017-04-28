defmodule OrgtoolDb.RewardTypesView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{reward_types: reward_types}) do
    %{reward_types: render_many(reward_types, OrgtoolDb.RewardTypesView, "reward_types.json")}
  end

  def render("show.json", %{reward_types: reward_types}) do
    %{reward_type: render_one(reward_types, OrgtoolDb.RewardTypesView, "reward_types.json")}
  end

  def render("reward_types.json", %{reward_types: reward_types}) do
    %{id: reward_types.id,
      name: reward_types.name,
      description: reward_types.description,
      img: reward_types.img,
      level: reward_types.level}
  end
end
