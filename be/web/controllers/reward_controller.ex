defmodule OrgtoolDb.RewardController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Reward
  alias OrgtoolDb.RewardType
  alias OrgtoolDb.Player

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, ship: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    rewards = Repo.all(Reward)
    render(conn, "index.json-api", data: rewards)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    changeset = Reward.changeset(%Reward{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, reward} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", reward_path(conn, :show, reward))
        |> render("show.json-api", data: reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    reward = Repo.get!(Reward, id)
    |> Repo.preload([:reward_type, :players])
    render(conn, "show.json-api", data: reward, opts: [include: "reward_type,players"])
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    reward = Repo.get!(Reward, id)
    |> Repo.preload([:players, :reward_type])

    changeset = Reward.changeset(reward, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, reward} ->
        render(conn, "show.json-api", data: reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    reward = Repo.get!(Reward, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reward)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Player, :players, relationships)
    |> maybe_apply(RewardType, "reward-type", :reward_type, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
