defmodule OrgtoolDb.ModelController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Model

  plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

  def index(conn, _params, _current_user, _claums) do
    models = Repo.all(Model)
    render(conn, "index.json", models: models)
  end

  def create(conn, %{"model" => model_params}, _current_user, _claums) do
    changeset = Model.changeset(%Model{}, model_params)

    case Repo.insert(changeset) do
      {:ok, model} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", model_path(conn, :show, model))
        |> render("show.json", model: model)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    model = Repo.get!(Model, id)
    render(conn, "show.json", model: model)
  end

  def update(conn, %{"id" => id, "model" => model_params}, _current_user, _claums) do
    model = Repo.get!(Model, id)
    changeset = Model.changeset(model, model_params)

    case Repo.update(changeset) do
      {:ok, model} ->
        render(conn, "show.json", model: model)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    model = Repo.get!(Model, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(model)

    send_resp(conn, :no_content, "")
  end
end
