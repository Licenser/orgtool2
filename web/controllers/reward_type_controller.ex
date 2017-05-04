defmodule OrgtoolDb.RewardTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.RewardType

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    reward_types = Repo.all(RewardType)
    render(conn, "index.json-api", data: reward_types)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = RewardType.changeset(%RewardType{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, reward_type} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", reward_type_path(conn, :show, reward_type))
        |> render("show.json-api", data: reward_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)
    |> Repo.preload([:rewards])
    render(conn, "show.json-api", data: reward_type, opts: [include: "rewards"])
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)
    |> Repo.preload(:rewards)

    changeset = RewardType.changeset(reward_type, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, reward_type} ->
        render(conn, "show.json-api", data: reward_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reward_type)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Rewards, :rewards, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
