defmodule OrgtoolDb.RewardTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.RewardType

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    reward_types = Repo.all(RewardType)
    render(conn, "index.json", reward_types: reward_types)
  end

  def create(conn, %{"reward_type" => reward_type_params}, _current_user, _claums) do
    changeset = RewardType.changeset(%RewardType{}, reward_type_params)

    case Repo.insert(changeset) do
      {:ok, reward_type} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", reward_type_path(conn, :show, reward_type))
        |> render("show.json", reward_type: reward_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)
    render(conn, "show.json", reward_type: reward_type)
  end

  def update(conn, %{"id" => id, "reward_type" => reward_type_params},
        _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)
    changeset = RewardType.changeset(reward_type, reward_type_params)

    case Repo.update(changeset) do
      {:ok, reward_type} ->
        render(conn, "show.json", reward_type: reward_type)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    reward_type = Repo.get!(RewardType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reward_type)

    send_resp(conn, :no_content, "")
  end
end
