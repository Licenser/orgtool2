defmodule OrgtoolDb.ItemTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ItemType

  def index(conn, _params) do
    item_types = Repo.all(ItemType) |> Repo.preload(:items)
    render(conn, "index.json", item_types: item_types)
  end

  def create(conn, %{"item_type" => item_type_params}) do
    changeset = ItemType.changeset(%ItemType{}, item_type_params)

    case Repo.insert(changeset) do
      {:ok, item_type} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_type_path(conn, :show, item_type))
        |> render("show.json", item_type: item_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item_type = Repo.get!(ItemType, id) |> Repo.preload(:items)
    render(conn, "show.json", item_type: item_type)
  end

  def update(conn, %{"id" => id, "item_type" => item_type_params}) do
    item_type = Repo.get!(ItemType, id)
    changeset = ItemType.changeset(item_type, item_type_params)

    case Repo.update(changeset) do
      {:ok, item_type} ->
        render(conn, "show.json", item_type: item_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_type = Repo.get!(ItemType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item_type)

    send_resp(conn, :no_content, "")
  end
end
