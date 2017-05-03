defmodule OrgtoolDb.UnitController do
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.Unit
  alias OrgtoolDb.Member

  if System.get_env("NO_AUTH") != "true" do
    plug Guardian.Plug.EnsureAuthenticated, handler: OrgtoolDb.SessionController, typ: "access"
  end

  def index(conn, _params, _current_user, _claums) do
    units = Repo.all(Unit) |> Repo.preload([:unit_type])
    render(conn, "index.json-api", data: units)
  end

  def create(conn, %{"id" => id,
                     "data" => %{"type" => "units", "attributes" => unit_params}}, _current_user, _claums) do

    changeset = Unit.changeset(%Unit{}, unit_params)

    case Repo.insert(changeset) do
      {:ok, unit} ->
        unit = unit |> Repo.preload([:unit_type])
        conn
        |> put_status(:created)
        |> put_resp_header("location", unit_path(conn, :show, unit))
        |> render("show.json-api", data: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user, _claums) do
    unit = Repo.get!(Unit, id) |> Repo.preload([:unit_type, :unit, :units, :members, :leaders, :applicants])
    render(conn, "show.json-api", data: unit, opts: [include: "unit,units,unit_type,members,leaders,applicants"])
  end

  def update(conn, %{"id" => id,
                     "data" => %{
                       "attributes" => unit_params,
                       "relationships" => relatioships}},
        _current_user, _claums) do
    unit = Repo.get!(Unit, id)
    |> Repo.preload([:leaders, :members, :applicants])

    changeset = Unit.changeset(unit, unit_params)
    |> apply_leaders(relatioships)
    |> apply_members(relatioships)
    |> apply_applicants(relatioships)

    case Repo.update(changeset) do
      {:ok, unit} ->
        unit = unit |> Repo.preload([:unit_type])
        render(conn, "show.json-api", data: unit)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(OrgtoolDb.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

    def id_int(b) when is_binary(b) do
    String.to_integer(b)
  end

  def id_int(b) do
    b
  end

  def apply_leaders(changeset, %{"leaders" => %{"data" => members}}) do
    :io.format("leaders: ~p~n", [members])

    members = for %{"id" => id, "type" => "members"} <- members do
      Repo.get!(Member, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :leaders, members)
  end
  def apply_leaders(changeset, _) do
    changeset
  end

  def apply_members(changeset, %{"members" => %{"data" => members}}) do
    :io.format("members: ~p~n", [members])
    members = for %{"id" => id, "type" => "members"} <- members do
      Repo.get!(Member, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :members, members)
  end
  def apply_members(changeset, _) do
    changeset
  end

  def apply_applicants(changeset, %{"applicants" => %{"data" => members}}) do
    :io.format("applicants: ~p~n", [members])
    members = for %{"id" => id, "type" => "members"} <- members do
      Repo.get!(Member, id_int(id))
    end
    Ecto.Changeset.put_assoc(changeset, :applicants, members)
  end
  def apply_applicants(changeset, _) do
    changeset
  end


  def delete(conn, %{"id" => id}, _current_user, _claums) do
    unit = Repo.get!(Unit, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(unit)

    send_resp(conn, :no_content, "")
  end
end
