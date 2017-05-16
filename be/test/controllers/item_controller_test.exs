defmodule OrgtoolDb.ItemControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Item
  alias OrgtoolDb.Template
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit

  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", name: "some content"}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, template} = %Template{} |> Repo.insert
    {:ok, player} = %Player{} |> Repo.insert
    {:ok, unit} = %Unit{} |> Repo.insert
    valid_data = %{
      attributes: @valid_attrs,
      relationships: %{
        template: %{data: %{type: "template", id: template.id}},
        player:   %{data: %{type: "player", id: player.id}},
        unit:     %{data: %{type: "unit", id: unit.id}},
      }
    }
    {:ok, %{valid_data: valid_data, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = get conn, item_path(conn, :show, item)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(item.id),
      "type"          => "item",
      "relationships" => %{
        "player"     => %{"data" => nil},
        "unit"       => %{"data" => nil},
        "template"   => %{"data" => nil},
        "item-props" => %{"data" => []},
      },
      "attributes"    => %{
        "available"   => item.available,
        "description" => item.description,
        "hidden"      => item.hidden,
        "img"         => item.img,
        "name"        => item.name
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, item_path(conn, :create), data: valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["template"]["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert response["data"]["relationships"]["unit"]["data"]["id"]
    assert Repo.get_by(Item, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, item_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    item = Repo.insert! %Item{}
    conn = put conn, item_path(conn, :update, item), id: item.id, data: valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["template"]["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert response["data"]["relationships"]["unit"]["data"]["id"]
    assert Repo.get_by(Item, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = put conn, item_path(conn, :update, item), id: item.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    item = Repo.insert! %Item{}
    conn = delete conn, item_path(conn, :delete, item)
    assert response(conn, 204)
    refute Repo.get(Item, item.id)
  end
end
