defmodule OrgtoolDb.RewardView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{rewards: rewards}) do
    %{rewards: render_many(rewards, OrgtoolDb.RewardView, "reward.json")}
  end

  def render("show.json", %{reward: reward}) do
    %{reward: render_one(reward, OrgtoolDb.RewardView, "reward.json")}
  end

  def render("reward.json", %{reward: reward}) do
    %{id: reward.id,
      description: reward.description,
      img: reward.img,
      level: reward.level,
      name: reward.name,
      type: reward.type}
  end
end
