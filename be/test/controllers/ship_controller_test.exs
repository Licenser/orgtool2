defmodule OrgtoolDb.ShipControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Ship
  alias OrgtoolDb.ShipModel
  alias OrgtoolDb.Player
  alias OrgtoolDb.Unit

  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", name: "some content"}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, model} = %ShipModel{} |> Repo.insert
    {:ok, player} = %Player{} |> Repo.insert
    {:ok, unit} = %Unit{} |> Repo.insert
    valid_data = %{
      attributes: @valid_attrs,
      relationships: %{
        "ship-model": %{data: %{type: "ship_model", id: model.id}},
        player:   %{data: %{type: "player", id: player.id}},
        unit:     %{data: %{type: "unit", id: unit.id}},
      }
    }
    {:ok, %{valid_data: valid_data, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, ship_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    ship = Repo.insert! %Ship{}
    conn = get conn, ship_path(conn, :show, ship)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(ship.id),
      "type"          => "ship",
      "relationships" => %{
        "player"        => %{"data" => nil},
        "unit"          => %{"data" => nil},
        "ship-model"    => %{"data" => nil},
      },
      "attributes"    => %{
        "available"     => ship.available,
        "description"   => ship.description,
        "hidden"        => ship.hidden,
        "img"           => ship.img,
        "name"          => ship.name,
        "unit-id"       => nil,
        "ship-model-id" => nil,

      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, ship_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, ship_path(conn, :create), data: valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["ship-model"]["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert response["data"]["relationships"]["unit"]["data"]["id"]
    assert Repo.get_by(Ship, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, ship_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    ship = Repo.insert! %Ship{}
    conn = put conn, ship_path(conn, :update, ship), id: ship.id, data: valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["ship-model"]["data"]["id"]
    assert response["data"]["relationships"]["player"]["data"]["id"]
    assert response["data"]["relationships"]["unit"]["data"]["id"]
    assert Repo.get_by(Ship, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    ship = Repo.insert! %Ship{}
    conn = put conn, ship_path(conn, :update, ship), id: ship.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    ship = Repo.insert! %Ship{}
    conn = delete conn, ship_path(conn, :delete, ship)
    assert response(conn, 204)
    refute Repo.get(Ship, ship.id)
  end
end
