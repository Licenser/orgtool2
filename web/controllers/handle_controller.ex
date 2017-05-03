defmodule OrgtoolDb.HandleController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Handle

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    handles = Repo.all(Handle)
    render(conn, "index.json-api", data: handles)
  end

  def create(conn, %{"handle" => handle_params}, _current_user, _claums) do
    changeset = Handle.changeset(%Handle{}, handle_params)

    case Repo.insert(changeset) do
      {:ok, handle} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", handle_path(conn, :show, handle))
        |> render("show.json-api", data: handle)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)
    render(conn, "show.json-api", data: handle)
  end

  def update(conn, %{"id" => id, "handle" => handle_params}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)
    changeset = Handle.changeset(handle, handle_params)

    case Repo.update(changeset) do
      {:ok, handle} ->
        render(conn, "show.json-api", data: handle)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(handle)

    send_resp(conn, :no_content, "")
  end
end
