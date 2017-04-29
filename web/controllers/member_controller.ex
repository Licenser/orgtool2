defmodule OrgtoolDb.MemberController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Member

  def index(conn, _params) do
    members = Repo.all(Member)
    render(conn, "index.json", members: members)
  end

  def create(conn, member_params) do
    changeset = Member.changeset(%Member{}, member_params)

    case Repo.insert(changeset) do
      {:ok, member} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_path(conn, :show, member))
        |> render("show.json", member: member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Repo.get!(Member, id)
    render(conn, "show.json", member: member)
  end

  def update(conn, %{"id" => id} = member_params) do
    member = Repo.get!(Member, id)
    changeset = Member.changeset(member, member_params)

    case Repo.update(changeset) do
      {:ok, member} ->
        render(conn, "show.json", member: member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Repo.get!(Member, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member)

    send_resp(conn, :no_content, "")
  end
end
