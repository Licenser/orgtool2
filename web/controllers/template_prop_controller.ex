defmodule OrgtoolDb.TemplatePropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.TemplateProp
  alias OrgtoolDb.Template

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, %{"template_id" => template_id}, _current_user, _claums) do
    template = Repo.get!(Template, template_id)
    |> Repo.preload(:template_props)
    render(conn, "index.json", template_props: template.template_props)
  end

  def index(conn, _params, _current_user, _claums) do
    template_props = Repo.all(TemplateProp)
    render(conn, "index.json", template_props: template_props)
  end

  def create(conn, %{"template_prop" => template_prop_params}, _current_user, _claums) do
    changeset = TemplateProp.changeset(%TemplateProp{}, template_prop_params)

    case Repo.insert(changeset) do
      {:ok, template_prop} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", template_prop_path(conn, :show, template_prop))
        |> render("show.json", template_prop: template_prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    template_prop = Repo.get!(TemplateProp, id)
    render(conn, "show.json", template_prop: template_prop)
  end

  def update(conn, %{"id" => id, "template_prop" => template_prop_params}) do
    template_prop = Repo.get!(TemplateProp, id)
    changeset = TemplateProp.changeset(template_prop, template_prop_params)

    case Repo.update(changeset) do
      {:ok, template_prop} ->
        render(conn, "show.json", template_prop: template_prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    template_prop = Repo.get!(TemplateProp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(template_prop)

    send_resp(conn, :no_content, "")
  end
end
