defmodule OrgtoolDb.ShipModelControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ShipModel
  @valid_attrs %{description: "some content", img: "some content", name: "some content", ship_id: 42}
  @valid_data %{attributes: @valid_attrs}

  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, %{conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, ship_model_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    ship_model = Repo.insert! %ShipModel{}
    conn = get conn, ship_model_path(conn, :show, ship_model)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(ship_model.id),
      "type"          => "ship-model",
      "attributes"    => %{
        "name" => ship_model.name,
        "img" => ship_model.img,
        "description" => ship_model.description,
        "class" => ship_model.class,
        "crew" => ship_model.crew,
        "length" => ship_model.length,
        "manufacturer" => ship_model.manufacturer,
        "mass" => ship_model.mass,
        "ship-id" => ship_model.ship_id
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, ship_model_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, ship_model_path(conn, :create), data: @valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert Repo.get_by(ShipModel, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, ship_model_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    ship_model = Repo.insert! %ShipModel{}
    conn = put conn, ship_model_path(conn, :update, ship_model), id: ship_model.id, data: @valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]

    assert Repo.get_by(ShipModel, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    ship_model = Repo.insert! %ShipModel{}
    conn = put conn, ship_model_path(conn, :update, ship_model), id: ship_model.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    ship_model = Repo.insert! %ShipModel{}
    conn = delete conn, ship_model_path(conn, :delete, ship_model)
    assert response(conn, 204)
    refute Repo.get(ShipModel, ship_model.id)
  end
end
