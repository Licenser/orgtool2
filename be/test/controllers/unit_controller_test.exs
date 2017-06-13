defmodule OrgtoolDb.UnitControllerTest do
  use OrgtoolDb.ConnCase#, async: false

  alias OrgtoolDb.Unit
  alias OrgtoolDb.UnitType
  alias OrgtoolDb.Player
  @valid_attrs %{color: "some content", description: "some content", img: "some content", name: "some content"}

  setup %{conn: conn} do
    {:ok, unit_type} = %UnitType{} |> Repo.insert
    {:ok, player} = %Player{} |> Repo.insert
    valid_data = %{
      attributes:    @valid_attrs,
      relationships: %{
        players: %{data: [%{id: player.id, type: "player"}]},
        unit_type: %{data: %{id: unit_type.id, type: "unit_type"}}}}
    type_id = Integer.to_string(unit_type.id)
    {:ok, %{
        type_id: type_id,
        valid_data: valid_data,
        conn: put_req_header(conn, "accept", "application/json"),
     }}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, unit_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    unit = Repo.insert! %Unit{}
    conn = get conn, unit_path(conn, :show, unit)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(unit.id),
      "type" => "unit",
      "attributes" => %{
        "name" => unit.name,
        "description" => unit.description,
        "color" => unit.color,
        "img" => unit.img
      },
      "relationships" => %{
        "applicants" => %{"data" => []},
        "leaders" => %{"data" => []},
        "players" => %{"data" => []},
        "unit" => %{"data" => nil},
        "ships" => %{"data" => []},
        "unit-type" => %{"data" => nil},
        "units" => %{"data" => []}}
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, unit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, unit_path(conn, :create), data: valid_data
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Unit, @valid_attrs)
  end


  test "creates and renders sub unit", %{conn: conn, type_id: type_id} do
    {:ok, unit} = %Unit{} |> Repo.insert
    unit_id = Integer.to_string(unit.id)
    payload = %{"data" => %{
               "attributes" => %{},
               "relationships" => %{
                 "applicants" => %{"data" => []},
                 "leaders" => %{"data" => []},
                 "players" => %{"data" => []},
                 "unit-type" => %{"data" => %{
                                 "id" => type_id,
                                 "type" => "unit-type"}},
                 "unit" => %{"data" => %{
                            "id" => unit_id,
                            "type" => "unit"}}
               },
               "type" => "unit"}}
    conn = post conn, unit_path(conn, :create), payload
    assert json_response(conn, 201)["data"]["id"]
    assert json_response(conn, 201)["data"]["relationships"]["unit-type"]["data"]["id"] == type_id
    assert json_response(conn, 201)["data"]["relationships"]["unit"]["data"]["id"] == unit_id
    #assert Repo.get_by(Unit, @valid_attrs)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, unit_path(conn, :create), unit: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    unit = Repo.insert! %Unit{}
    conn = put conn, unit_path(conn, :update, unit), id: unit.id, data: valid_data
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Unit, @valid_attrs)
  end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   unit = Repo.insert! %Unit{}
  #   conn = put conn, unit_path(conn, :update, unit), unit: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "deletes chosen resource", %{conn: conn} do
    unit = Repo.insert! %Unit{}
    conn = delete conn, unit_path(conn, :delete, unit)
    assert response(conn, 204)
    refute Repo.get(Unit, unit.id)
  end
end
