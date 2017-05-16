defmodule OrgtoolDb.SessionView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, OrgtoolDb.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, OrgtoolDb.SessionView, "session.json")}
    #render_one(session, OrgtoolDb.SessionView, "session.json")
  end

  def render("session.json", %{session: session}) do
    %{id: session.id,
      user: %{
        id: session.id,
        wp_id: session.id,
        user_login: session.email,
        user_nicename: session.name,
        display_name: session.name,
        user_registered: "",
        img: "img",
        isadmin: session.is_admin}}
  end
end
