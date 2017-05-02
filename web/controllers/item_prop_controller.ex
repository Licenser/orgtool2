defmodule OrgtoolDb.ItemPropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ItemProp
  alias OrgtoolDb.Item

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, %{"item_id" => item_id}, _current_user, _claums) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:props)
    render(conn, "index.json", item_props: item.props)
  end

  def index(conn, _params, _current_user, _claums) do
    item_props = Repo.all(ItemProp)
    render(conn, "index.json", item_props: item_props)
  end

  def create(conn, %{"item_prop" => prop_params}, _current_user, _claums) do
    changeset = ItemProp.changeset(%ItemProp{}, prop_params)

    case Repo.insert(changeset) do
      {:ok, prop} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_prop_path(conn, :show, prop))
        |> render("show.json", item_prop: prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)
    render(conn, "show.json", item_prop: prop)
  end

  def update(conn, %{"id" => id, "item_prop" => prop_params}, _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)
    changeset = ItemProp.changeset(prop, prop_params)

    case Repo.update(changeset) do
      {:ok, prop} ->
        render(conn, "show.json", item_prop: prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(ItemProp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(prop)

    send_resp(conn, :no_content, "")
  end
end
