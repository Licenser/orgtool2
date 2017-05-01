defmodule OrgtoolDb.MemberUnitView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{member_units: member_units}) do
    %{member_units: render_many(member_units, OrgtoolDb.MemberUnitView, "member_unit.json")}
  end

  def render("show.json", %{member_unit: member_unit}) do
    %{member_unit: render_one(member_unit, OrgtoolDb.MemberUnitView, "member_unit.json")}
  end

  def render("member_unit.json", %{member_unit: member_unit}) do
    %{id: member_unit.id,
      member_id: member_unit.member_id,
      reward_id: member_unit.reward_id,
      unit_id: member_unit.unit_id}
  end
end
