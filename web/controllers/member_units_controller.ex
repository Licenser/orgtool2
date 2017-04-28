defmodule OrgtoolDb.MemberUnitsController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.MemberUnits

  def index(conn, _params) do
    member_units = Repo.all(MemberUnits)
    render(conn, "index.json", member_units: member_units)
  end

  def create(conn, %{"member_units" => member_units_params}) do
    changeset = MemberUnits.changeset(%MemberUnits{}, member_units_params)

    case Repo.insert(changeset) do
      {:ok, member_units} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_units_path(conn, :show, member_units))
        |> render("show.json", member_units: member_units)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member_units = Repo.get!(MemberUnits, id)
    render(conn, "show.json", member_units: member_units)
  end

  def update(conn, %{"id" => id, "member_units" => member_units_params}) do
    member_units = Repo.get!(MemberUnits, id)
    changeset = MemberUnits.changeset(member_units, member_units_params)

    case Repo.update(changeset) do
      {:ok, member_units} ->
        render(conn, "show.json", member_units: member_units)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member_units = Repo.get!(MemberUnits, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member_units)

    send_resp(conn, :no_content, "")
  end
end
