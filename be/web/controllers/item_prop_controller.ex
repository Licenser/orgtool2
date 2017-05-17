defmodule OrgtoolDb.ItemPropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ItemProp
  alias OrgtoolDb.Item

  @preload [:item]
  @opts [include: "item"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(read)]

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    item_props = Repo.all(ItemProp)
    render(conn, "index.json-api", data: item_props)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = ItemProp.changeset(%ItemProp{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, prop} ->
        prop = prop |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_prop_path(conn, :show, prop))
        |> render("show.json-api", data: prop, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: prop, opts: @opts)
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)
    |> Repo.preload(@preload)

    changeset = ItemProp.changeset(prop, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, prop} ->
        prop = prop |> Repo.preload(@preload)
        render(conn, "show.json-api", data: prop, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(prop)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Item, :item, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
