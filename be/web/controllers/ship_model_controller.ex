defmodule OrgtoolDb.ShipModelController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ShipModel

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship_model: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship_model: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship_model: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship_model: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    ship_models = Repo.all(ShipModel)
    render(conn, "index.json-api", data: ship_models)
  end

  def create(conn, %{"data" => %{"attributes" => params}}, _current_user, _claums) do
    changeset = ShipModel.changeset(%ShipModel{}, params)

    case Repo.insert(changeset) do
      {:ok, ship_model} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ship_model_path(conn, :show, ship_model))
        |> render("show.json-api", data: ship_model)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    ship_model = Repo.get!(ShipModel, id)
    render(conn, "show.json-api", data: ship_model)
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => params}},
        _current_user, _claums) do
    ship_model = Repo.get!(ShipModel, id)

    changeset = ShipModel.changeset(ship_model, params)

    case Repo.update(changeset) do
      {:ok, ship_model} ->
        render(conn, "show.json-api", data: ship_model)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    ship_model = Repo.get!(ShipModel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(ship_model)

    send_resp(conn, :no_content, "")
  end
end
