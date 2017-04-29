defmodule OrgtoolDb.RewardTypeController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.RewardType

  def index(conn, _params) do
    reward_types = Repo.all(RewardType)
    render(conn, "index.json", reward_types: reward_types)
  end

  def create(conn, %{"reward_types" => reward_types_params}) do
    changeset = RewardType.changeset(%RewardType{}, reward_types_params)

    case Repo.insert(changeset) do
      {:ok, reward_types} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", reward_type_path(conn, :show, reward_types))
        |> render("show.json", reward_types: reward_types)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reward_types = Repo.get!(RewardType, id)
    render(conn, "show.json", reward_types: reward_types)
  end

  def update(conn, %{"id" => id, "reward_types" => reward_types_params}) do
    reward_types = Repo.get!(RewardType, id)
    changeset = RewardType.changeset(reward_types, reward_types_params)

    case Repo.update(changeset) do
      {:ok, reward_types} ->
        render(conn, "show.json", reward_types: reward_types)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reward_types = Repo.get!(RewardType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reward_types)

    send_resp(conn, :no_content, "")
  end
end
