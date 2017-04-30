defmodule OrgtoolDb.PageController do
  use OrgtoolDb.Web, :controller
  #alias OrgtoolDb.Repo

  def index(conn, _params, current_user, _claims) do
    render conn, "index.html", current_user: current_user
  end
end
