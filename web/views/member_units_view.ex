defmodule OrgtoolDb.MemberUnitsView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{member_units: member_units}) do
    %{member_units: render_many(member_units, OrgtoolDb.MemberUnitsView, "member_units.json")}
  end

  def render("show.json", %{member_units: member_units}) do
    %{member_unit: render_one(member_units, OrgtoolDb.MemberUnitsView, "member_units.json")}
  end

  def render("member_units.json", %{member_units: member_units}) do
    %{id: member_units.id,
      member: member_units.member_id,
      reward: member_units.reward_id,
      unit: member_units.unit_id}
  end
end
