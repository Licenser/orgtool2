defmodule OrgtoolDb.ItemPropControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ItemProp
  alias OrgtoolDb.Item
  @valid_attrs %{name: "some content", value: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, item} = %Item{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :item_id, item.id)

    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_prop_path(conn, :index)
    assert json_response(conn, 200)["item_props"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = get conn, item_prop_path(conn, :show, prop)
    assert json_response(conn, 200)["item_prop"] == %{"id" => prop.id,
      "name" => prop.name,
      "value" => prop.value,
      "item_id" => prop.item_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_prop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, item_prop_path(conn, :create), item_prop: valid_attrs
    assert json_response(conn, 201)["item_prop"]["id"]
    assert Repo.get_by(ItemProp, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_prop_path(conn, :create), item_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    prop = Repo.insert! %ItemProp{}
    conn = put conn, item_prop_path(conn, :update, prop), item_prop: valid_attrs
    assert json_response(conn, 200)["item_prop"]["id"]
    assert Repo.get_by(ItemProp, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = put conn, item_prop_path(conn, :update, prop), item_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = delete conn, item_prop_path(conn, :delete, prop)
    assert response(conn, 204)
    refute Repo.get(ItemProp, prop.id)
  end
end
