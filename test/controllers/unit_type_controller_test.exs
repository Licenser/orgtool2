defmodule OrgtoolDb.UnitTypeControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.UnitType
  alias OrgtoolDb.Unit
  @valid_attrs %{description: "some content", img: "some content", name: "some content", ordering: 42}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, unit} = %Unit{} |> Repo.insert
    valid_data = %{
      attributes:    @valid_attrs,
      relationships: %{
        units: %{data: [%{id: unit.id, type: "unit"}]}
      }
    }
    {:ok, %{valid_data: valid_data,
            conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, unit_type_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = get conn, unit_type_path(conn, :show, unit_type)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(unit_type.id),
      "type" => "unit-type",
      "relationships" => %{
        "units" => %{"data" => []}
      },
      "attributes" => %{
        "description" => unit_type.description,
        "img" => unit_type.img,
        "name" => unit_type.name,
        "ordering" => unit_type.ordering
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, unit_type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, unit_type_path(conn, :create), data: valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["units"]["data"]
    assert Repo.get_by(UnitType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, unit_type_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    unit_type = Repo.insert! %UnitType{}
    conn = put conn, unit_type_path(conn, :update, unit_type), id: unit_type.id, data: valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["units"]["data"]
    assert Repo.get_by(UnitType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = put conn, unit_type_path(conn, :update, unit_type), id: unit_type.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = delete conn, unit_type_path(conn, :delete, unit_type)
    assert response(conn, 204)
    refute Repo.get(UnitType, unit_type.id)
  end
end
