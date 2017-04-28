defmodule OrgtoolDb.ItemTypeControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ItemType
  @valid_attrs %{description: "some content", img: "some content", name: "some content", permissions: 42, typeName: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_type_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item_type = Repo.insert! %ItemType{}
    conn = get conn, item_type_path(conn, :show, item_type)
    assert json_response(conn, 200)["data"] == %{"id" => item_type.id,
      "name" => item_type.name,
      "typeName" => item_type.typeName,
      "description" => item_type.description,
      "img" => item_type.img,
      "permissions" => item_type.permissions}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, item_type_path(conn, :create), item_type: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ItemType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_type_path(conn, :create), item_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    item_type = Repo.insert! %ItemType{}
    conn = put conn, item_type_path(conn, :update, item_type), item_type: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ItemType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item_type = Repo.insert! %ItemType{}
    conn = put conn, item_type_path(conn, :update, item_type), item_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    item_type = Repo.insert! %ItemType{}
    conn = delete conn, item_type_path(conn, :delete, item_type)
    assert response(conn, 204)
    refute Repo.get(ItemType, item_type.id)
  end
end
