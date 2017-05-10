defmodule OrgtoolDb.MemberController do
  use OrgtoolDb.Web, :controller
  alias OrgtoolDb.Member
  alias OrgtoolDb.Unit
  alias OrgtoolDb.User
  alias OrgtoolDb.Handle
  alias OrgtoolDb.Reward

  @preload [:rewards, :user, :handles, :leaderships, :memberships, :applications, :items]
  @opts [include: "user,rewards,handles,memberships,applications,leaderships,items"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    members = Repo.all(Member)
    render(conn, "index.json-api", data: members)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}},
                     _current_user, _claums) do
    changeset = Member.changeset(%Member{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, member} ->
        member = member |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_path(conn, :show, member))
        |> render("show.json-api", data: member, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    member = Repo.get!(Member, id)
    |> Repo.preload(@preload)
      render(conn, "show.json-api", data: member, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    member = Repo.get!(Member, id)
    |> Repo.preload(@preload)

    changeset = Member.changeset(member, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, member} ->
        member = member |> Repo.preload(@preload)
        render(conn, "show.json-api", data: member, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    member = Repo.get!(Member, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(User,   :user, relationships)
    |> maybe_apply(Item,   :items, relationships)
    |> maybe_apply(Reward, :rewards, relationships)
    |> maybe_apply(Handle, :handles, relationships)
    |> maybe_apply(Unit, :leaderships, relationships)
    |> maybe_apply(Unit, :memberships, relationships)
    |> maybe_apply(Unit, :applications, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
