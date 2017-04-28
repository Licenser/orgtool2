defmodule OrgtoolDb.UnitTypeControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.UnitType
  @valid_attrs %{description: "some content", img: "some content", name: "some content", ordering: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, unit_type_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = get conn, unit_type_path(conn, :show, unit_type)
    assert json_response(conn, 200)["data"] == %{"id" => unit_type.id,
      "description" => unit_type.description,
      "img" => unit_type.img,
      "name" => unit_type.name,
      "ordering" => unit_type.ordering}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, unit_type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, unit_type_path(conn, :create), unit_type: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UnitType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, unit_type_path(conn, :create), unit_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = put conn, unit_type_path(conn, :update, unit_type), unit_type: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UnitType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = put conn, unit_type_path(conn, :update, unit_type), unit_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    unit_type = Repo.insert! %UnitType{}
    conn = delete conn, unit_type_path(conn, :delete, unit_type)
    assert response(conn, 204)
    refute Repo.get(UnitType, unit_type.id)
  end
end
