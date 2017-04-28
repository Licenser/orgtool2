defmodule OrgtoolDb.ItemPropsController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ItemProps

  def index(conn, _params) do
    item_props = Repo.all(ItemProps)
    render(conn, "index.json", item_props: item_props)
  end

  def create(conn, %{"item_props" => item_props_params}) do
    changeset = ItemProps.changeset(%ItemProps{}, item_props_params)

    case Repo.insert(changeset) do
      {:ok, item_props} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", item_props_path(conn, :show, item_props))
        |> render("show.json", item_props: item_props)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item_props = Repo.get!(ItemProps, id)
    render(conn, "show.json", item_props: item_props)
  end

  def update(conn, %{"id" => id, "item_props" => item_props_params}) do
    item_props = Repo.get!(ItemProps, id)
    changeset = ItemProps.changeset(item_props, item_props_params)

    case Repo.update(changeset) do
      {:ok, item_props} ->
        render(conn, "show.json", item_props: item_props)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item_props = Repo.get!(ItemProps, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item_props)

    send_resp(conn, :no_content, "")
  end
end
