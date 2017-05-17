defmodule OrgtoolDb.TemplatePropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.TemplateProp
  alias OrgtoolDb.Template

  @preload [:template]
  @opts [include: "template"]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
    plug EnsurePermissions, default: [:active], handler: OrgtoolDb.SessionController
  end

  def index(conn, _params, _current_user, _claums) do
    template_props = Repo.all(TemplateProp)
    render(conn, "index.json-api", data: template_props)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = TemplateProp.changeset(%TemplateProp{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, template_prop} ->
        template_prop = template_prop |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", template_prop_path(conn, :show, template_prop))
        |> render("show.json-api", data: template_prop, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    template_prop = Repo.get!(TemplateProp, id)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: template_prop, opts: @opts)
  end

  def update(conn,  %{"id" => id, "data" => data = %{"attributes" => params}} , _current_user, _claums) do
    template_prop = Repo.get!(TemplateProp, id)
    |> Repo.preload(@preload)

    changeset = TemplateProp.changeset(template_prop, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, template_prop} ->
        template_prop = template_prop |> Repo.preload(@preload)
        render(conn, "show.json-api", data: template_prop, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    template_prop = Repo.get!(TemplateProp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(template_prop)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Template, :template, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
