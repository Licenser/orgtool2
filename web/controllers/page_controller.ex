defmodule OrgtoolDb.PageController do
  use OrgtoolDb.Web, :controller
  #alias OrgtoolDb.Repo

  def index(conn, _params, current_user, _claims) do
    csrf = Plug.CSRFProtection.get_csrf_token;
    jwt = Guardian.Plug.current_token(conn)
    conn
    |> put_layout(false)
    |> render("index.html", jwt: jwt, csrf: csrf)
  end
end
