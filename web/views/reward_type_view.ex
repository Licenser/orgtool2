defmodule OrgtoolDb.RewardTypeView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{reward_types: reward_types}) do
    %{reward_types: render_many(reward_types, OrgtoolDb.RewardTypeView, "reward_type.json")}
  end

  def render("show.json", %{reward_type: reward_type}) do
    %{reward_type: render_one(reward_type, OrgtoolDb.RewardTypeView, "reward_type.json")}
  end

  def render("reward_type.json", %{reward_type: reward_type}) do
    %{id: reward_type.id,
      name: reward_type.name,
      description: reward_type.description,
      img: reward_type.img,
      level: reward_type.level}
  end
end
