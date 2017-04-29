defmodule OrgtoolDb.SessionController do
  use OrgtoolDb.Web, :controller

  # alias OrgtoolDb.Session

  def dummy() do
    %{
      is_admin: true,
      is_user: false,
      user_id: 1,
      fancy_bg: true
    }
  end
  def index(conn, _params) do
    session = dummy()
    render(conn, "show.json", session: session)
  end

  def create(conn, _params) do
    session = dummy()
    render(conn, "show.json", session: session)
  end
end
