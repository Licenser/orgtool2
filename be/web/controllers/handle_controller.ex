defmodule OrgtoolDb.HandleController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Handle
  alias OrgtoolDb.Player

  @preload [:player]
  @opts [include: "player"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read)] when action in [:index, :show]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    handles = Repo.all(Handle)
    render(conn, "index.json-api", data: handles)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = Handle.changeset(%Handle{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, handle} ->
        handle = handle |> Repo.preload(:player)

        conn
        |> put_status(:created)
        |> put_resp_header("location", handle_path(conn, :show, handle))
        |> render("show.json-api", data: handle, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: handle, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{
                       "attributes" => params}}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)
    |> Repo.preload(:player)

    changeset = Handle.changeset(handle, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, handle} ->
        handle = handle |> Repo.preload(:player)
        render(conn, "show.json-api", data: handle, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    handle = Repo.get!(Handle, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(handle)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Player, :player, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
