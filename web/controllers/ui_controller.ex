defmodule OrgtoolDb.UiController do
  use OrgtoolDb.Web, :controller
  #alias OrgtoolDb.Repo

  def index(conn, _params, _current_user, _claims) do
    conn
    |> put_layout(false)
    |> render("index.html", jwt: Guardian.Plug.current_token(conn))

  end
end
