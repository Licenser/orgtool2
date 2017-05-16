defmodule OrgtoolDb.SessionController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.User

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

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

  def create(conn, _params, nil, _claums) do
    ## TODO redirect
    if System.get_env("NO_AUTH") == "true" do
      session = %{
        id: 0,
        is_admin: true,
        name: "dev",
        email: "dev@dev.dev"
      }
      render(conn, "show.json", session: session)
    end
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

  def unauthorized(conn, _params) do
    conn
    |> send_resp(403, "{'error': 'not authorized'}")
    |> halt
  end

  def unauthenticated(conn, _params) do
    conn
    |> send_resp(401, "{'error': 'not authenticated'}")
    |> halt
  end

end
