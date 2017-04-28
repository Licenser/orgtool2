defmodule OrgtoolDb.PropControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Prop
  @valid_attrs %{description: "some content", img: "some content", item: 42, name: "some content", type: 42, unit: 42, value: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, prop_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    prop = Repo.insert! %Prop{}
    conn = get conn, prop_path(conn, :show, prop)
    assert json_response(conn, 200)["data"] == %{"id" => prop.id,
      "name" => prop.name,
      "value" => prop.value,
      "description" => prop.description,
      "img" => prop.img,
      "item" => prop.item,
      "type" => prop.type,
      "unit" => prop.unit}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, prop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, prop_path(conn, :create), prop: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Prop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, prop_path(conn, :create), prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    prop = Repo.insert! %Prop{}
    conn = put conn, prop_path(conn, :update, prop), prop: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Prop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    prop = Repo.insert! %Prop{}
    conn = put conn, prop_path(conn, :update, prop), prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    prop = Repo.insert! %Prop{}
    conn = delete conn, prop_path(conn, :delete, prop)
    assert response(conn, 204)
    refute Repo.get(Prop, prop.id)
  end
end
