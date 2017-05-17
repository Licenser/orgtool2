defmodule OrgtoolDb.UnitTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.UnitType
  alias OrgtoolDb.Unit

  @preload [:units]
  @opts [include: "units"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    unit_types = Repo.all(UnitType)
    render(conn, "index.json-api", data: unit_types)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = UnitType.changeset(%UnitType{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, unit_type} ->
        unit_type = unit_type |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_type_path(conn, :show, unit_type))
        |> render("show.json-api", data: unit_type, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: unit_type, opts: @opts)
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)
    |> Repo.preload(@preload)

    changeset = UnitType.changeset(unit_type, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, unit_type} ->
        unit_type = unit_type |> Repo.preload(@preload)
        render(conn, "show.json-api", data: unit_type, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    unit_type = Repo.get!(UnitType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(unit_type)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Unit, :units, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
