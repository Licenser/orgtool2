defmodule OrgtoolDb.ItemPropsControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ItemProps
  @valid_attrs %{item: 42, prop: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_props_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item_props = Repo.insert! %ItemProps{}
    conn = get conn, item_props_path(conn, :show, item_props)
    assert json_response(conn, 200)["data"] == %{"id" => item_props.id,
      "item" => item_props.item,
      "prop" => item_props.prop}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_props_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, item_props_path(conn, :create), item_props: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ItemProps, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_props_path(conn, :create), item_props: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    item_props = Repo.insert! %ItemProps{}
    conn = put conn, item_props_path(conn, :update, item_props), item_props: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ItemProps, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item_props = Repo.insert! %ItemProps{}
    conn = put conn, item_props_path(conn, :update, item_props), item_props: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    item_props = Repo.insert! %ItemProps{}
    conn = delete conn, item_props_path(conn, :delete, item_props)
    assert response(conn, 204)
    refute Repo.get(ItemProps, item_props.id)
  end
end
