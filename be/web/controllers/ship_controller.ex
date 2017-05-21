defmodule OrgtoolDb.ShipController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Ship
  alias OrgtoolDb.ShipModel
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit

  @opts [include: "player,ship_model,unit"]
  @preload [:player, :ship_model, :unit]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(read)]

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    ships = Repo.all(Ship)
    render(conn, "index.json-api", data: ships)
  end


  def create(conn, %{"data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    changeset = Ship.changeset(%Ship{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, ship} ->
        ship = ship
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", ship_path(conn, :show, ship))
        |> render("show.json-api", data: ship, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    ship = Repo.get!(Ship, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: ship, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{
                       "attributes" => params}},
        _current_user, _claums) do

    ship = Repo.get!(Ship, id)
    |> Repo.preload(@preload)

    changeset = Ship.changeset(ship, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, ship} ->
        ship = ship
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: ship, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    ship = Repo.get!(Ship, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(ship)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(ShipModel, :ship_model, relationships)
    |> maybe_apply(Player,   :player, relationships)
    |> maybe_apply(Unit,     :unit, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
