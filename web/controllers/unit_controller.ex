defmodule OrgtoolDb.UnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Unit

  def index(conn, _params) do
    units = Repo.all(Unit)
    render(conn, "index.json", units: units)
  end

  def create(conn, %{"unit" => unit_params}) do
    changeset = Unit.changeset(%Unit{}, unit_params)

    case Repo.insert(changeset) do
      {:ok, unit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_path(conn, :show, unit))
        |> render("show.json", unit: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    unit = Repo.get!(Unit, id)
    render(conn, "show.json", unit: unit)
  end

  def update(conn, %{"id" => id, "unit" => unit_params}) do
    unit = Repo.get!(Unit, id)
    changeset = Unit.changeset(unit, unit_params)

    case Repo.update(changeset) do
      {:ok, unit} ->
        render(conn, "show.json", unit: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    unit = Repo.get!(Unit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(unit)

    send_resp(conn, :no_content, "")
  end
end
