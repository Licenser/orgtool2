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
      log: member_units.log,
      member: member_units.member,
      reward: member_units.reward,
      unit: member_units.unit}
  end
end
