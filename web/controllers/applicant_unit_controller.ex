defmodule OrgtoolDb.ApplicantUnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.ApplicantUnit

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params) do
    applicant_units = Repo.all(ApplicantUnit)
    render(conn, "index.json", applicant_units: applicant_units)
  end

  def create(conn, %{"applicant_unit" => applicant_unit_params}) do
    changeset = ApplicantUnit.changeset(%ApplicantUnit{}, applicant_unit_params)

    case Repo.insert(changeset) do
      {:ok, applicant_unit} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", applicant_unit_path(conn, :show, applicant_unit))
        |> render("show.json", applicant_unit: applicant_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    applicant_unit = Repo.get!(ApplicantUnit, id)
    render(conn, "show.json", applicant_unit: applicant_unit)
  end

  def update(conn, %{"id" => id, "applicant_unit" => applicant_unit_params}) do
    applicant_unit = Repo.get!(ApplicantUnit, id)
    changeset = ApplicantUnit.changeset(applicant_unit, applicant_unit_params)

    case Repo.update(changeset) do
      {:ok, applicant_unit} ->
        render(conn, "show.json", applicant_unit: applicant_unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    applicant_unit = Repo.get!(ApplicantUnit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(applicant_unit)

    send_resp(conn, :no_content, "")
  end
end
