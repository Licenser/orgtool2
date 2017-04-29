defmodule OrgtoolDb.PropTypeControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.PropType
  @valid_attrs %{description: "some content", img: "some content", name: "some content", type_name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, prop_type_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    prop_type = Repo.insert! %PropType{}
    conn = get conn, prop_type_path(conn, :show, prop_type)
    assert json_response(conn, 200)["data"] == %{"id" => prop_type.id,
      "name" => prop_type.name,
      "type_name" => prop_type.type_name,
      "img" => prop_type.img,
      "description" => prop_type.description}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, prop_type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, prop_type_path(conn, :create), prop_type: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PropType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, prop_type_path(conn, :create), prop_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    prop_type = Repo.insert! %PropType{}
    conn = put conn, prop_type_path(conn, :update, prop_type), prop_type: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PropType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    prop_type = Repo.insert! %PropType{}
    conn = put conn, prop_type_path(conn, :update, prop_type), prop_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    prop_type = Repo.insert! %PropType{}
    conn = delete conn, prop_type_path(conn, :delete, prop_type)
    assert response(conn, 204)
    refute Repo.get(PropType, prop_type.id)
  end
end
