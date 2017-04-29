defmodule OrgtoolDb.PropTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.PropType

  def index(conn, _params) do
    prop_types = Repo.all(PropType)
    render(conn, "index.json", prop_types: prop_types)
  end

  def create(conn, %{"prop_type" => prop_type_params}) do
    changeset = PropType.changeset(%PropType{}, prop_type_params)

    case Repo.insert(changeset) do
      {:ok, prop_type} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", prop_type_path(conn, :show, prop_type))
        |> render("show.json", prop_type: prop_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    prop_type = Repo.get!(PropType, id)
    render(conn, "show.json", prop_type: prop_type)
  end

  def update(conn, %{"id" => id, "prop_type" => prop_type_params}) do
    prop_type = Repo.get!(PropType, id)
    changeset = PropType.changeset(prop_type, prop_type_params)

    case Repo.update(changeset) do
      {:ok, prop_type} ->
        render(conn, "show.json", prop_type: prop_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    prop_type = Repo.get!(PropType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(prop_type)

    send_resp(conn, :no_content, "")
  end
end
