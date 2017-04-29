defmodule OrgtoolDb.MemberRewardView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{member_rewards: member_rewards}) do
    %{data: render_many(member_rewards, OrgtoolDb.MemberRewardView, "member_reward.json")}
  end

  def render("show.json", %{member_reward: member_reward}) do
    %{data: render_one(member_reward, OrgtoolDb.MemberRewardView, "member_reward.json")}
  end

  def render("member_reward.json", %{member_reward: member_reward}) do
    %{id: member_reward.id,
      reward_id: member_reward.reward_id,
      member_id: member_reward.member_id}
  end
end
