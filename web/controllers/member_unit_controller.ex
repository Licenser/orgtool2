defmodule OrgtoolDb.MemberUnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.MemberUnit

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    member_units = Repo.all(MemberUnit)
    render(conn, "index.json-api", data: member_units)
  end

  def create(conn, %{"data" => %{"type" => "member_units",
                                 "attributes" => member_unit_params}},
        _current_user, _claums) do
    changeset = MemberUnit.changeset(%MemberUnit{}, member_unit_params)

    case Repo.insert(changeset) do
      {:ok, member_unit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_unit_path(conn, :show, member_unit))
        |> render("show.json-api", data: member_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    member_unit = Repo.get!(MemberUnit, id)
    render(conn, "show.json-api", data: member_unit)
  end

  def update(conn, %{"id" => id, "data" => %{"type" => "member_units",
                                             "attributes" => member_unit_params}},
        _current_user, _claums) do

    member_unit = Repo.get!(MemberUnit, id)
    changeset = MemberUnit.changeset(member_unit, member_unit_params)

    case Repo.update(changeset) do
      {:ok, member_unit} ->
        render(conn, "show.json-api", data: member_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claums) do
    member_unit = Repo.get!(MemberUnit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member_unit)

    send_resp(conn, :no_content, "")
  end
end
