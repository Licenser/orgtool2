defmodule OrgtoolDb.ItemControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Item
  alias OrgtoolDb.Template
  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, template} = %Template{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :template_id, template.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_path(conn, :index)
    assert json_response(conn, 200)["items"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = get conn, item_path(conn, :show, item)
    assert json_response(conn, 200)["item"] == %{"id" => item.id,
      "available" => item.available,
      "description" => item.description,
      "hidden" => item.hidden,
      "img" => item.img,
      "member_id" => item.member_id,
      "name" => item.name,
      "template_id" => item.template_id,
      "unit_id" => item.unit_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, item_path(conn, :create), item: valid_attrs
    assert json_response(conn, 201)["item"]["id"]
    assert Repo.get_by(Item, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_path(conn, :create), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    item = Repo.insert! %Item{}
    conn = put conn, item_path(conn, :update, item), item: valid_attrs
    assert json_response(conn, 200)["item"]["id"]
    assert Repo.get_by(Item, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = delete conn, item_path(conn, :delete, item)
    assert response(conn, 204)
    refute Repo.get(Item, item.id)
  end
end
