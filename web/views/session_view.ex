defmodule OrgtoolDb.SessionView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{sessions: sessions}) do
    %{sessions: render_many(sessions, OrgtoolDb.SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{user: render_one(session, OrgtoolDb.SessionView, "session.json")}
    #render_one(session, OrgtoolDb.SessionView, "session.json")
  end

  def render("session.json", %{session: session}) do
    %{isAdmin: session.is_admin,
      isUser: session.is_user,
      user: session.user_id,
      fancyBG: session.fancy_bg}
  end
end
