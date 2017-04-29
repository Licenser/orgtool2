defmodule OrgtoolDb.MemberView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{members: members}) do
    %{members: render_many(members, OrgtoolDb.MemberView, "member.json")}
  end

  def render("show.json", %{member: member}) do
    %{member: render_one(member, OrgtoolDb.MemberView, "member.json")}
  end

  def render("member.json", %{member: member}) do
    %{id: member.id,
      name: member.name,
      avatar: member.avatar,
      logs: member.logs,
      timezone: member.timezone}
  end
end
