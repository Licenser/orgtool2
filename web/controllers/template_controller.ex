defmodule OrgtoolDb.TemplateController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Template
  alias OrgtoolDb.Category

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, %{"category_id" => category_id}, _current_user, _claums) do
    category = Repo.get!(Category, category_id)
    |> Repo.preload(:templates)
    render(conn, "index.json-api", data: category.templates)
  end

  def index(conn, _params, _current_user, _claums) do
    templates = Repo.all(Template)
    render(conn, "index.json-api", data: templates)
  end

  def create(conn, %{"template" => template_params} = params, _current_user, _claums) do
    template_params = case params do
                        %{"category_id" => category_id} ->
                          Map.put(template_params, "category_id", category_id);
                        _ ->
                          template_params
                      end
    changeset = Template.changeset(%Template{}, template_params)

    case Repo.insert(changeset) do
      {:ok, template} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", template_path(conn, :show, template))
        |> render("show.json-api", data: template)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    template = Repo.get!(Template, id)
    render(conn, "show.json-api", data: template)
  end

  def update(conn, %{"id" => id, "template" => template_params}, _current_user, _claums) do
    template = Repo.get!(Template, id)
    changeset = Template.changeset(template, template_params)

    case Repo.update(changeset) do
      {:ok, template} ->
        render(conn, "show.json-api", data: template)
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
end
