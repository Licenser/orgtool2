defmodule OrgtoolDb.CategoryController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Category
  alias OrgtoolDb.Template

  @preload [:templates]
  @opts [include: "templates"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, category: ~w(read)]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, category: ~w(create)] when action in [:create]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, category: ~w(edit)] when action in [:update]
    plug EnsurePermissions, [handler: OrgtoolDb.SessionController, category: ~w(delete)] when action in [:delete]
  end

  def index(conn, _params, _current_user, _claums) do
    categorys = Repo.all(Category)
    render(conn, "index.json-api", data: categorys)
  end

  def create(conn, %{"data" => data = %{"attributes" => category_params}},
        _current_user, _claums) do
    changeset = Category.changeset(%Category{}, category_params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, category} ->
        category = category |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", category_path(conn, :show, category))
        |> render("show.json-api", data: category, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    category = Repo.get!(Category, id)
    render(conn, "show.json-api", data: category, opts: @opts)
  end

  def update(conn, %{"id" => id,
                     "data" => %{
                       "attributes" => category_params}}, _current_user, _claums) do
    category = Repo.get!(Category, id)
    |> Repo.preload(@preload)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        category = category |> Repo.preload(@preload)
        render(conn, "show.json-api", data: category, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Template, :templates, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
