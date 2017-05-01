defmodule OrgtoolDb.ModelPropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ModelProp

  plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"

  def index(conn, _params, _current_user, _claums) do
    model_props = Repo.all(ModelProp)
    render(conn, "index.json", model_props: model_props)
  end

  def create(conn, %{"model_prop" => model_prop_params}, _current_user, _claums) do
    changeset = ModelProp.changeset(%ModelProp{}, model_prop_params)

    case Repo.insert(changeset) do
      {:ok, model_prop} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", model_prop_path(conn, :show, model_prop))
        |> render("show.json", model_prop: model_prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    model_prop = Repo.get!(ModelProp, id)
    render(conn, "show.json", model_prop: model_prop)
  end

  def update(conn, %{"id" => id, "model_prop" => model_prop_params}) do
    model_prop = Repo.get!(ModelProp, id)
    changeset = ModelProp.changeset(model_prop, model_prop_params)

    case Repo.update(changeset) do
      {:ok, model_prop} ->
        render(conn, "show.json", model_prop: model_prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    model_prop = Repo.get!(ModelProp, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(model_prop)

    send_resp(conn, :no_content, "")
  end
end
