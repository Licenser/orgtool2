defmodule OrgtoolDb.UnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Unit
  alias OrgtoolDb.UnitType
  alias OrgtoolDb.Player

  import Ecto.Query, only: [from: 2]
  @preload [:leaders, :players, :applicants, :unit_type, :unit, :units]
  @opts [include: "unit,units,unit_type,players,leaders,applicants"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, unit: ~w(delete)] when action in [:delete]
    # TODO: handle assign, accept and apply
  end

  def index(conn, _params, _current_user, _claums) do
    units = Repo.all(Unit) |> Repo.preload([:unit_type])
    render(conn, "index.json-api", data: units)
  end

  def create(conn, payload = %{"data" => %{"attributes" => params}}, _current_user, _claums) do

    changeset = Unit.changeset(%Unit{}, params)
    |> handle_rels(payload, &do_add_res/2)

    case Repo.insert(changeset) do
      {:ok, unit} ->
        unit = unit |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_path(conn, :show, unit))
        |> render("show.json-api", data: unit, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => uid, "recursive" => "true"}, _current_user, _claums) do
    uid_i = String.to_integer(uid)
    units = Repo.all(
      from u in Unit,
      join: ut in fragment("""
  WITH RECURSIVE unit_tree AS (
      SELECT *
      FROM units
      WHERE units.id = ?
    UNION ALL
      SELECT ut0.*
      FROM units ut0
      INNER JOIN unit_tree ut ON ut.id = ut0.unit_id
  ) SELECT * FROM unit_tree
  """, ^uid_i),
      on: u.id == ut.id)
    |> Repo.preload([:unit_type, :unit, :units, :players, :leaders, :applicants])
    render(conn, "index.json-api", data: units, opts: @opts)

  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    unit = Repo.get!(Unit, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: unit, opts: @opts)
  end

  def update(conn, payload = %{"id" => id,
                               "data" => %{
                                 "attributes" => params}},
        _current_user, _claums) do
    unit = Repo.get!(Unit, id)
    |> Repo.preload(@preload)

    changeset = Unit.changeset(unit, params)
    |> handle_rels(payload, &do_add_res/2)

    case Repo.update(changeset) do
      {:ok, unit} ->
        unit = unit |> Repo.preload(@preload)
        render(conn, "show.json-api", data: unit, opts: @opts)
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

  defp do_add_res(changeset, elements) do
    changeset
    |> maybe_apply(Unit, :unit, elements)
    |> maybe_apply(UnitType, "unit-type", :unit_type, elements)
    |> maybe_apply(Player, :leaders, elements)
    |> maybe_apply(Player, :players, elements)
    |> maybe_apply(Player, :applications, elements)
  end
end
