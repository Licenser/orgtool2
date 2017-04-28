defmodule OrgtoolDb.RewardController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Reward

  def index(conn, _params) do
    rewards = Repo.all(Reward)
    render(conn, "index.json", rewards: rewards)
  end

  def create(conn, %{"reward" => reward_params}) do
    changeset = Reward.changeset(%Reward{}, reward_params)

    case Repo.insert(changeset) do
      {:ok, reward} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", reward_path(conn, :show, reward))
        |> render("show.json", reward: reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reward = Repo.get!(Reward, id)
    render(conn, "show.json", reward: reward)
  end

  def update(conn, %{"id" => id, "reward" => reward_params}) do
    reward = Repo.get!(Reward, id)
    changeset = Reward.changeset(reward, reward_params)

    case Repo.update(changeset) do
      {:ok, reward} ->
        render(conn, "show.json", reward: reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reward = Repo.get!(Reward, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(reward)

    send_resp(conn, :no_content, "")
  end
end
