defmodule OrgtoolDb.ShipController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Ship
  alias OrgtoolDb.ShipModel
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit
  alias Ecto.Changeset

  @idx_opts [include: "ship_model,player"]
  @idx_preload [:ship_model, :player]
  @opts [include: "player,ship_model,unit"]
  @preload [:unit] ++ @idx_preload


  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController

    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(read)]

    # plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(create)] when action in [:create]
    # plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(edit)] when action in [:update]
    # plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    ships = Repo.all(Ship)
    |> Repo.preload(@idx_preload)
    render(conn, "index.json-api", data: ships, opts: @idx_opts)
  end


  def create(conn, payload = %{"data" => data = %{"attributes" => params}},
        current_user, {:ok, claims}) do

    perms = Guardian.Permissions.from_claims(claims, :ship)

    changeset = Ship.changeset(%Ship{}, params)
    |> maybe_add_rels(data)
    player_id = case Changeset.get_field(changeset, :player) do
                  nil ->
                    nil;
                  player ->
                    Map.get(player, :id)
                end
    if same_player?(current_user, player_id) or
    Guardian.Permissions.all?(perms, [:create], :ship) do
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
    else
      OrgtoolDb.SessionController.unauthorized(conn, payload)
    end

  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    ship = Repo.get!(Ship, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: ship, opts: @opts)
  end

  def update(conn, payload = %{"id" => id,
                               "data" => data = %{
                                 "attributes" => params}},
        current_user, {:ok, claims}) do

    perms = Guardian.Permissions.from_claims(claims, :ship)

    ship = Repo.get!(Ship, id)
    |> Repo.preload(@preload)

    if same_player?(current_user, ship.player.id) or
    Guardian.Permissions.all?(perms, [:edit], :ship) do
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
    else
      OrgtoolDb.SessionController.unauthorized(conn, payload)
    end

  end

  def delete(conn, payload = %{"id" => id}, current_user, {:ok, claims}) do
    perms = Guardian.Permissions.from_claims(claims, :ship)
    ship = Repo.get!(Ship, id)
    |> Repo.preload(@preload)

    if same_player?(current_user, ship.player.id) or
    Guardian.Permissions.all?(perms, [:delete], :ship) do
      # Here we use delete! (with a bang) because we expect
      # it to always work (and if it does not, it will raise).
      Repo.delete!(ship)
      send_resp(conn, :no_content, "")
    else
      OrgtoolDb.SessionController.unauthorized(conn, payload)
    end
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(ShipModel, "ship-model", :ship_model, relationships)
    |> maybe_apply(Player,   :player, relationships)
    |> maybe_apply(Unit,     :unit, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
