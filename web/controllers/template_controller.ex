defmodule OrgtoolDb.TemplateController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Template
  alias OrgtoolDb.Category
  alias OrgtoolDb.TemplateProp

  @opts [include: "template_props,category"]
  @idx_opts [include: "category"]
  @preload [:template_props]
  @always_preload [:category]

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    templates = Repo.all(Template)
    |> Repo.preload(@always_preload)
    render(conn, "index.json-api", data: templates, opts: @idx_opts)
  end

  def create(conn, %{"data" => data = %{"attributes" => params}}, _current_user, _claums) do
    changeset = Template.changeset(%Template{}, params)
    |> maybe_add_rels(data)

    case Repo.insert(changeset) do
      {:ok, template} ->
        template = template
        |> Repo.preload(@always_preload)
        |> Repo.preload(@preload)
        conn
        |> put_status(:created)
        |> put_resp_header("location", template_path(conn, :show, template))
        |> render("show.json-api", data: template, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    template = Repo.get!(Template, id)
    |> Repo.preload(@always_preload)
    |> Repo.preload(@preload)
    render(conn, "show.json-api", data: template, opts: @opts)
  end

  def update(conn, %{"id" => id, "data" => data = %{"attributes" => params}},
        _current_user, _claums) do
    template = Repo.get!(Template, id)
    |> Repo.preload(@always_preload)
    |> Repo.preload(@preload)

    changeset = Template.changeset(template, params)
    |> maybe_add_rels(data)

    case Repo.update(changeset) do
      {:ok, template} ->
        template = template
        |> Repo.preload(@always_preload)
        |> Repo.preload(@preload)
        render(conn, "show.json-api", data: template, opts: @opts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    template = Repo.get!(Template, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(template)

    send_resp(conn, :no_content, "")
  end

  defp maybe_add_rels(changeset, %{"relationships" => relationships}) do
    changeset
    |> maybe_apply(Category, :category, relationships)
    |> maybe_apply(TemplateProp, :template_props, relationships)
  end

  defp maybe_add_rels(changeset, _) do
    changeset
  end
end
