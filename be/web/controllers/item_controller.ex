defmodule OrgtoolDb.ItemController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Item
  alias OrgtoolDb.Template
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit
  alias OrgtoolDb.ItemProp

  @opts [include: "player,template,unit,item_props"]
  @list_opts [include: "item_props"]
  @list_preload [:item_props]
  @preload [:player, :template, :unit, :item_props]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(read)]

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, item: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    items = Repo.all(Item)
    |> Repo.preload(@list_preload)
    render(conn, "index.json-api", data: items, opts: @list_opts)
  end


  def create(conn, %{"data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    changeset = Item.changeset(%Item{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, item} ->
        item = item
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json-api", data: item, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    item = Repo.get!(Item, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: item, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{
                       "attributes" => params}},
        _current_user, _claums) do

    item = Repo.get!(Item, id)
    |> Repo.preload(@preload)

    changeset = Item.changeset(item, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, item} ->
        item = item
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: item, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Template, :template, relationships)
    |> maybe_apply(Player,   :player, relationships)
    |> maybe_apply(Unit,     :unit, relationships)
    |> maybe_apply(ItemProp, :item_props, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
