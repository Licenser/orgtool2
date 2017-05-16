defmodule OrgtoolDb.PermissionController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Permission
  alias OrgtoolDb.User

  @opts [include: "user"]
  @preload [:user]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    permissions = Repo.all(Permission)
    render(conn, "index.json-api", data: permissions)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = Permission.changeset(%Permission{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, permission} ->
        permission = permission
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", permission_path(conn, :show, permission))
        |> render("show.json-api", data: permission, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    permission = Repo.get!(Permission, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: permission, opts: @opts)
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}}, _current_user, _claums) do
    permission = Repo.get!(Permission, id)
    |> Repo.preload(@preload)

    changeset = Permission.changeset(permission, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, permission} ->
        permission = permission
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: permission, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    permission = Repo.get!(Permission, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(permission)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(User, :user, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
