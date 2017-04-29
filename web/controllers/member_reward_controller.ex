defmodule OrgtoolDb.MemberRewardController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.MemberReward

  def index(conn, _params) do
    member_rewards = Repo.all(MemberReward)
    render(conn, "index.json", member_rewards: member_rewards)
  end

  def create(conn, %{"member_reward" => member_reward_params}) do
    changeset = MemberReward.changeset(%MemberReward{}, member_reward_params)

    case Repo.insert(changeset) do
      {:ok, member_reward} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_reward_path(conn, :show, member_reward))
        |> render("show.json", member_reward: member_reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member_reward = Repo.get!(MemberReward, id)
    render(conn, "show.json", member_reward: member_reward)
  end

  def update(conn, %{"id" => id, "member_reward" => member_reward_params}) do
    member_reward = Repo.get!(MemberReward, id)
    changeset = MemberReward.changeset(member_reward, member_reward_params)

    case Repo.update(changeset) do
      {:ok, member_reward} ->
        render(conn, "show.json", member_reward: member_reward)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member_reward = Repo.get!(MemberReward, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member_reward)

    send_resp(conn, :no_content, "")
  end
end
