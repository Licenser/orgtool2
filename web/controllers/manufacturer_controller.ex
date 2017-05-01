defmodule OrgtoolDb.ManufacturerController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Manufacturer

  plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

  def index(conn, _params, _current_user, _claums) do
    manufacturers = Repo.all(Manufacturer)
    render(conn, "index.json", manufacturers: manufacturers)
  end

  def create(conn, %{"manufacturer" => manufacturer_params}, _current_user, _claums) do
    changeset = Manufacturer.changeset(%Manufacturer{}, manufacturer_params)

    case Repo.insert(changeset) do
      {:ok, manufacturer} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", manufacturer_path(conn, :show, manufacturer))
        |> render("show.json", manufacturer: manufacturer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    manufacturer = Repo.get!(Manufacturer, id)
    render(conn, "show.json", manufacturer: manufacturer)
  end

  def update(conn, %{"id" => id, "manufacturer" => manufacturer_params}, _current_user, _claums) do
    manufacturer = Repo.get!(Manufacturer, id)
    changeset = Manufacturer.changeset(manufacturer, manufacturer_params)

    case Repo.update(changeset) do
      {:ok, manufacturer} ->
        render(conn, "show.json", manufacturer: manufacturer)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    manufacturer = Repo.get!(Manufacturer, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(manufacturer)

    send_resp(conn, :no_content, "")
  end
end
