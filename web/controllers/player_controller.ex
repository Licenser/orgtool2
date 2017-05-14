defmodule OrgtoolDb.PlayerController do
  use OrgtoolDb.Web, :controller
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit
  alias OrgtoolDb.User
  alias OrgtoolDb.Handle
  alias OrgtoolDb.Reward

  @preload [:rewards, :user, :handles, :leaderships, :playerships, :applications, :items]
  @opts [include: "user,rewards,handles,playerships,applications,leaderships,items"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, player: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, player: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, player: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, player: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    players = Repo.all(Player)
    render(conn, "index.json-api", data: players)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}},
                     _current_user, _claums) do
    changeset = Player.changeset(%Player{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, player} ->
        player = player |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", player_path(conn, :show, player))
        |> render("show.json-api", data: player, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    player = Repo.get!(Player, id)
    |> Repo.preload(@preload)
      render(conn, "show.json-api", data: player, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    player = Repo.get!(Player, id)
    |> Repo.preload(@preload)

    changeset = Player.changeset(player, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, player} ->
        player = player |> Repo.preload(@preload)
        render(conn, "show.json-api", data: player, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    player = Repo.get!(Player, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(player)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(User,   :user, relationships)
    |> maybe_apply(Item,   :items, relationships)
    |> maybe_apply(Reward, :rewards, relationships)
    |> maybe_apply(Handle, :handles, relationships)
    |> maybe_apply(Unit, "unit", "leaderships", :leaderships, relationships)
    |> maybe_apply(Unit, "unit", "playerships", :playerships, relationships)
    |> maybe_apply(Unit, "unit", "applications", :applications, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
