defmodule OrgtoolDb.PageController do
  use OrgtoolDb.Web, :controller
  #alias OrgtoolDb.Repo

  def index(conn, _params, current_user, _claims) do
    case Guardian.Plug.current_token(conn) do
      nil ->
        render conn, "index.html", current_user: current_user
      jwt ->
        conn
        |> put_layout(false)
        |> render("ui.html", jwt: jwt)
    end
  end
end
