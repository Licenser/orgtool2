defmodule OrgtoolDb.LeaderUnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.LeaderUnit

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    leader_units = Repo.all(LeaderUnit)
    render(conn, "index.json", leader_units: leader_units)
  end

  def create(conn, %{"leader_unit" => leader_unit_params}, _current_user, _claums) do
    changeset = LeaderUnit.changeset(%LeaderUnit{}, leader_unit_params)

    case Repo.insert(changeset) do
      {:ok, leader_unit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", leader_unit_path(conn, :show, leader_unit))
        |> render("show.json", leader_unit: leader_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    leader_unit = Repo.get!(LeaderUnit, id)
    render(conn, "show.json", leader_unit: leader_unit)
  end

  def update(conn, %{"id" => id, "leader_unit" => leader_unit_params}, _current_user, _claums) do
    leader_unit = Repo.get!(LeaderUnit, id)
    changeset = LeaderUnit.changeset(leader_unit, leader_unit_params)

    case Repo.update(changeset) do
      {:ok, leader_unit} ->
        render(conn, "show.json", leader_unit: leader_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    leader_unit = Repo.get!(LeaderUnit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(leader_unit)

    send_resp(conn, :no_content, "")
  end
end
