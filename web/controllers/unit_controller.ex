defmodule OrgtoolDb.UnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Unit
  alias OrgtoolDb.UnitType
  alias OrgtoolDb.Member

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    units = Repo.all(Unit)
    |> Repo.preload([:unit_type, :unit, :units, :members, :leaders, :applicants])
    render(conn, "index.json-api", data: units)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do

    changeset = Unit.changeset(%Unit{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, unit} ->
        unit = unit
         |> Repo.preload([:unit_type, :unit, :units, :members, :leaders, :applicants])
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_path(conn, :show, unit))
        |> render("show.json-api", data: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    unit = Repo.get!(Unit, id)
     |> Repo.preload([:unit_type, :unit, :units, :members, :leaders, :applicants])
    render(conn, "show.json-api", data: unit) #, opts: [include: "unit,units,unit_type,members,leaders,applicants"])
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{
                       "attributes" => params}},
        _current_user, _claums) do
    unit = Repo.get!(Unit, id)
#      |> Repo.preload([:leaders, :members, :applicants, :unit_type, :unit])
     |> Repo.preload([:unit_type, :unit, :units, :members, :leaders, :applicants])

    changeset = Unit.changeset(unit, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, unit} ->
        unit = unit |> Repo.preload([:unit_type])
        render(conn, "show.json-api", data: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    unit = Repo.get!(Unit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(unit)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Unit, :unit, relationships)
    |> maybe_apply(UnitType, :unit_type, relationships)
    |> maybe_apply(Member, :leaders, relationships)
    |> maybe_apply(Member, :members, relationships)
    |> maybe_apply(Member, :applications, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
