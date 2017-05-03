defmodule OrgtoolDb.MemberController do
  use OrgtoolDb.Web, :controller
  alias OrgtoolDb.Member
  alias OrgtoolDb.Unit

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    members = Repo.all(Member)
    render(conn, "index.json-api", data: members)
  end

  def create(conn, %{"member" => member_params}, _current_user, _claums) do
    changeset = Member.changeset(%Member{}, member_params)

    case Repo.insert(changeset) do
      {:ok, member} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_path(conn, :show, member))
        |> render("show.json-api", data: member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    member = Repo.get!(Member, id)
    |> Repo.preload([:rewards, :user, :handles, :leaderships, :memberships, :applications])
      render(conn, "show.json-api", data: member, opts: [include: "user,rewards,handles,memberships,applications,leaderships"])
  end
  
  def update(conn, %{"id" => id,
                     "data" => %{
                       "attributes" => member_params,
                       "relationships" => relatioships}} = d, _current_user, _claums) do
    :io.format("d: ~p~n", [d])
    member = Repo.get!(Member, id)
    |> Repo.preload([:leaderships, :memberships, :applications])

    changeset = Member.changeset(member, member_params)
    |> apply_leaderships(relatioships)
    |> apply_memberships(relatioships)
    |> apply_applications(relatioships)
    
    :io.format("member: ~p~n", [member])
    :io.format("changeset: ~p~n", [changeset])

    case Repo.update(changeset) do
      {:ok, member} ->
        render(conn, "show.json-api", data: member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "member" => member_params}, _current_user, _claums) do
    member = Repo.get!(Member, id)
    changeset = Member.changeset(member, member_params)

    case Repo.update(changeset) do
      {:ok, member} ->
        render(conn, "show.json-api", data: member)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end


  def id_int(b) when is_binary(b) do
    String.to_integer(b)
  end

  def id_int(b) do
    b
  end

  # %{"leaderships" => %{"data" => [%{"id" => "2", "type" => "units"}}}, "type" => "members"}
  def apply_leaderships(changeset, %{"leaderships" => %{"data" => units}}) do
    :io.format("leaderships: ~p~n", [units])

    units = for %{"id" => id, "type" => "units"} <- units do
      Repo.get!(Unit, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :leaderships, units)
  end
  def apply_leaderships(changeset, _) do
    changeset
  end

  def apply_memberships(changeset, %{"memberships" => %{"data" => units}}) do
    :io.format("memberships: ~p~n", [units])
    units = for %{"id" => id, "type" => "units"} <- units do
      Repo.get!(Unit, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :memberships, units)
  end
  def apply_memberships(changeset, _) do
    changeset
  end

    def apply_applications(changeset, %{"applications" => %{"data" => units}}) do
    :io.format("applications: ~p~n", [units])
    units = for %{"id" => id, "type" => "units"} <- units do
      Repo.get!(Unit, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :applications, units)
  end
  def apply_applications(changeset, _) do
    changeset
  end


  def delete(conn, %{"id" => id}, _current_user, _claums) do
    member = Repo.get!(Member, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member)

    send_resp(conn, :no_content, "")
  end
end
