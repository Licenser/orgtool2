defmodule OrgtoolDb.UserApiController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.User
  alias OrgtoolDb.Permission

  @opts [include: "permission,player"]
  @preload [:permission, :player]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
    # plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read)] when action in [:index, :show]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, user: ~w(read delete)] when action in [:delete]
  end

  def index(conn, _params, current_user, {:ok, claims}) do
    perms = Guardian.Permissions.from_claims(claims, :user)
    users = if Guardian.Permissions.all?(perms, [:read], :user) do
      Repo.all(User)
    else
      [current_user]
    end
    render(conn, "index.json-api", data: users)
  end

  def index(conn, params, _current_user, _claims) do
    if System.get_env("NO_AUTH") == "true" do
      users = Repo.all(User)
      render(conn, "index.json-api", data: users)
    else
      OrgtoolDb.SessionController.unauthenticated(conn, params)
    end
  end

  def create(conn, payload = %{"data" => %{"attributes" => params}},
        _current_user, _claums) do
    params = JaSerializer.ParamParser.parse(params)

    changeset = User.changeset(%User{}, params)
    |> handle_rels(payload, &do_add_res/2)

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

  def show(conn, params = %{"id" => id}, current_user, {:ok, claims}) do
    perms = Guardian.Permissions.from_claims(claims, :player)
    id = String.to_integer(id)
    if Guardian.Permissions.all?(perms, [:read], :player) or current_user.id == id do
      user = Repo.get!(User, id)
      |> Repo.preload(@preload)
      render(conn, "show.json-api", data: user, opts: @opts)
    else
      OrgtoolDb.SessionController.unauthorized(conn, params)
    end
  end

  def show(conn, params = %{"id" => id}, _current_user, _claims) do
    if System.get_env("NO_AUTH") == "true" do
      user = Repo.get!(User, id)
      |> Repo.preload(@preload)
      render(conn, "show.json-api", data: user, opts: @opts)
    else
      OrgtoolDb.SessionController.unauthorized(conn, params)
    end
  end

  def update(conn, payload = %{"id" => id,
                               "data" => %{
                                 "attributes" => params}},
        _current_user, _claums) do

    user = Repo.get!(User, id)
    |> Repo.preload(@preload)

    params = JaSerializer.ParamParser.parse(params)
    
    changeset = User.changeset(user, params)
    |> handle_rels(payload, &do_add_res/2)

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
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def new(conn, _params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  defp do_add_res(changeset, elements) do
    changeset
    |> maybe_apply(Permission, :permission, elements)
  end

end
