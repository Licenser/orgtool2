defmodule OrgtoolDb.ItemController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Item

  def index(conn, _params, _current_user, _claums) do
    items = Repo.all(Item) |> Repo.preload(:items)
    render(conn, "index.json", items: items)
  end

  def create(conn, %{"item" => item_params = %{"type" => item_type_id,
                                               "parent" => item_id}},
        _current_user, _claums) do
    item_params = item_params
    |> Map.put("item_type_id",  item_type_id)
    |> Map.put("item_id",  item_id)

    item_params = case item_params do
                    %{ "img" => img } when img != <<>> ->
                      :io.format("img: ~p~n", [img])
                      item_params;
                    _ ->
                      parent = Repo.get!(Item, item_id)
                      Map.put(item_params, "img", parent.img)
                  end
    item_params = case item_params do
                    %{ "member" => member_id } ->
                      Map.put(item_params, "member_id", member_id);
                    _ ->
                      item_params
                  end
    changeset = Item.changeset(%Item{}, item_params)

    case Repo.insert(changeset) do
      {:ok, item} ->
        item = item |> Repo.preload(:items)
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_path(conn, :show, item))
        |> render("show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do

    item = Repo.get!(Item, id) |> Repo.preload(:items)

    render(conn, "show.json", item: item)
  end

  def update(conn, item_params = %{"id" => id,
                                   "type" => item_type_id,
                                   "parent" => item_id},
        _current_user, _claums) do
    item_params = item_params
    |> Map.put("item_type_id",  item_type_id)
    |> Map.put("item_id",  item_id)

    item_params = case item_params do
                    %{ "member" => member_id } ->
                      Map.put(item_params, "member_id", member_id);
                    _ ->
                      item_params
                  end

    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        item = item |> Repo.preload(:items)
        render(conn, "show.json", item: item)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
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
