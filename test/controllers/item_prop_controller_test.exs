defmodule OrgtoolDb.ItemPropControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ItemProp
  alias OrgtoolDb.Item
  @valid_attrs %{name: "some content", value: "some content"}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, item} = %Item{} |> Repo.insert
    valid_data = %{
      attributes:    @valid_attrs,
      relationships: %{
        item: %{data: %{id: item.id, type: "item"}}
      }
    }
    {:ok, %{valid_data: valid_data,
            invalid_data: %{attributes: @invalid_attrs},
            conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_prop_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = get conn, item_prop_path(conn, :show, prop)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(prop.id),
      "type" => "item-prop",

      "attributes" => %{
        "name" => prop.name,
        "value" => prop.value,
      },
      "relationships" => %{"item" => %{}}
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_prop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, item_prop_path(conn, :create), data: valid_data
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ItemProp, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_prop_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    prop = Repo.insert! %ItemProp{}
    conn = put conn, item_prop_path(conn, :update, prop), id: prop.id, data: valid_data
    assert json_response(conn, 200) == "bla"
    assert Repo.get_by(ItemProp, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = put conn, item_prop_path(conn, :update, prop), id: prop.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    prop = Repo.insert! %ItemProp{}
    conn = delete conn, item_prop_path(conn, :delete, prop)
    assert response(conn, 204)
    refute Repo.get(ItemProp, prop.id)
  end
end
