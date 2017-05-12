defmodule OrgtoolDb.UserController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.User
  alias OrgtoolDb.Permission

  @opts [include: "permission"]
  @preload [:permission]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    users = Repo.all(User)
    render(conn, "index.json-api", data: users)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    changeset = User.changeset(%User{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, user} ->
        user = user
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json-api", data: user, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    user = Repo.get!(User, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: user, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => data = %{
                       "attributes" => params}},
        _current_user, _claums) do

    user = Repo.get!(User, id)
    |> Repo.preload(@preload)

    changeset = User.changeset(user, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, user} ->
        user = user
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: user, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    send_resp(conn, :no_content, "")
  end

  def new(conn, _params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Permission, :permission, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end

end
