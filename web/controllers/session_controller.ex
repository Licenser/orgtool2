defmodule OrgtoolDb.SessionController do
  use OrgtoolDb.Web, :controller
  alias OrgtoolDb.User
  # alias OrgtoolDb.Session


  plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController

  def dummy() do
    %{
      is_admin: false,
      is_user: false,
      user_id: 1,
      fancy_bg: true
    }
  end

  def index(_conn, _params, nil, _claums) do
    ## TODO redirect
  end

  def index(conn, _params, %User{is_admin: is_admin, id: user_id, name: name, email: email}, _claums) do
    session = %{
      id: user_id,
      is_admin: is_admin,
      name: name,
      email: email
    }
    render(conn, "show.json", session: session)
  end

  def create(_conn, _params, nil, _claums) do
    ## TODO redirect
  end

  def create(conn, _params, %User{is_admin: is_admin, id: user_id, name: name, email: email}, _claums) do
    session = %{
      id: user_id,
      is_admin: is_admin,
      name: name,
      email: email
    }
    render(conn, "show.json", session: session)
  end

  def unauthenticated(conn, _params) do
    conn
    |> send_resp(401, "{'error': 'not authenticated'}")
    |> halt
  end

end
