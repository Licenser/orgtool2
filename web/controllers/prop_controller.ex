defmodule OrgtoolDb.PropController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Prop
  alias OrgtoolDb.Item

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, %{"item_id" => item_id}, _current_user, _claums) do
    item = Repo.get!(Item, item_id)
    |> Repo.preload(:props)
    render(conn, "index.json", props: item.props)
  end

  def index(conn, _params, _current_user, _claums) do
    props = Repo.all(Prop)
    render(conn, "index.json", props: props)
  end

  def create(conn, %{"prop" => prop_params}, _current_user, _claums) do
    changeset = Prop.changeset(%Prop{}, prop_params)

    case Repo.insert(changeset) do
      {:ok, prop} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", prop_path(conn, :show, prop))
        |> render("show.json", prop: prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(Prop, id)
    render(conn, "show.json", prop: prop)
  end

  def update(conn, %{"id" => id, "prop" => prop_params}, _current_user, _claums) do
    prop = Repo.get!(Prop, id)
    changeset = Prop.changeset(prop, prop_params)

    case Repo.update(changeset) do
      {:ok, prop} ->
        render(conn, "show.json", prop: prop)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    prop = Repo.get!(Prop, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(prop)

    send_resp(conn, :no_content, "")
  end
end
