defmodule OrgtoolDb.MemberUnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.MemberUnit

  def index(conn, _params) do
    member_units = Repo.all(MemberUnit)
    render(conn, "index.json", member_units: member_units)
  end

  def create(conn, %{"memberUnit" => %{"member" => member_id, "unit" => unit_id, "reward" => reward_id}}) do
    member_unit_params = %{member_id: member_id, unit_id: unit_id, reward_id: reward_id}
    changeset = MemberUnit.changeset(%MemberUnit{}, member_unit_params)

    case Repo.insert(changeset) do
      {:ok, member_unit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", member_unit_path(conn, :show, member_unit))
        |> render("show.json", member_unit: member_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member_unit = Repo.get!(MemberUnit, id)
    render(conn, "show.json", member_unit: member_unit)
  end

  def update(conn, %{"id" => id, "member" => member_id, "unit" => unit_id, "reward" => reward_id}) do
    member_unit_params = %{member_id: member_id, unit_id: unit_id, reward_id: reward_id}
    member_unit = Repo.get!(MemberUnit, id)
    changeset = MemberUnit.changeset(member_unit, member_unit_params)

    case Repo.update(changeset) do
      {:ok, member_unit} ->
        render(conn, "show.json", member_unit: member_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member_unit = Repo.get!(MemberUnit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(member_unit)

    send_resp(conn, :no_content, "")
  end
end
