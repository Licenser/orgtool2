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

  def create(conn,  payload = %{"data" => %{"attributes" => params}},
        _current_user, _claums) do
    changeset = Player.changeset(%Player{}, params)
    |> handle_rels(payload, &do_add_res/2)

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

  def update(conn, payload = %{"id" => id, "data" => %{"attributes" => params}},
        _current_user, _claums) do
    player = Repo.get!(Player, id)
    |> Repo.preload(@preload)

    changeset = Player.changeset(player, params)
    |> handle_rels(payload, &do_add_res/2)

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

  defp do_add_res(changeset, elements) do
    :io.format("~p~n", [elements])
    changeset
    |> maybe_apply(User,   :user, elements)
    |> maybe_apply(Item,   "item",   "items", :items, elements)
    |> maybe_apply(Reward, "reward", "rewards", :rewards, elements)
    |> maybe_apply(Handle, "handle", "handles", :handles, elements)
    |> maybe_apply(Unit,   "unit",   "leaderships", :leaderships, elements)
    |> maybe_apply(Unit,   "unit",   "playerships", :playerships, elements)
    |> maybe_apply(Unit,   "unit",   "applications", :applications, elements)
  end
end
