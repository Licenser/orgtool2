defmodule OrgtoolDb.ItemPermController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ItemPerm
  alias OrgtoolDb.User

  @opts [include: "user"]
  @preload [:user]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    item_perms = Repo.all(ItemPerm)
    render(conn, "index.json-api", data: item_perms)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = ItemPerm.changeset(%ItemPerm{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, item_perm} ->
        item_perm = item_perm
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_perm_path(conn, :show, item_perm))
        |> render("show.json-api", data: item_perm, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    item_perm = Repo.get!(ItemPerm, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: item_perm, opts: @opts)
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}}, _current_user, _claums) do
    item_perm = Repo.get!(ItemPerm, id)
    |> Repo.preload(@preload)

    changeset = ItemPerm.changeset(item_perm, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, item_perm} ->
        item_perm = item_perm
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: item_perm, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    item_perm = Repo.get!(ItemPerm, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item_perm)

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
