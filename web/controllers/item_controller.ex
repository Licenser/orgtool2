defmodule OrgtoolDb.ItemController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Item
  alias OrgtoolDb.Template

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    items = Repo.all(Item)
    render(conn, "index.json-api", data: items)
  end


  def create(conn, %{"item" => item_params = %{"template_id" => template_id}},
        _current_user, _claums) do

    item_params = case item_params do
                    %{ "img" => img } when img != <<>> ->
                      item_params;
                    _ ->
                      parent = Repo.get!(Template, template_id)
                      Map.put(item_params, "img", parent.img)
                  end
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json-api", data: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def create(conn, %{"item" => item_params},
        _current_user, _claums) do

    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json-api", data: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    item = Repo.get!(Item, id)
    render(conn, "show.json-api", data: item)
  end

  def update(conn, %{"id" => id, "item" => item_params}, _current_user, _claums) do

    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        render(conn, "show.json-api", data: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    send_resp(conn, :no_content, "")
  end
end
