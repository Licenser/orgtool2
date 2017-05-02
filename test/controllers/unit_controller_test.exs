defmodule OrgtoolDb.UnitControllerTest do
  use OrgtoolDb.ConnCase#, async: false

  alias OrgtoolDb.Unit
  alias OrgtoolDb.UnitType
  @valid_attrs %{color: "some content", description: "some content", img: "some content", name: "some content", unit_type_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, unit_type} = %UnitType{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :unit_type_id, unit_type.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, unit_path(conn, :index)
    assert json_response(conn, 200)["units"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    unit = Repo.insert! %Unit{}
    conn = get conn, unit_path(conn, :show, unit)
    assert json_response(conn, 200)["unit"] == %{
      "id" => unit.id,
      "name" => unit.name,
      "description" => unit.description,
      "color" => unit.color,
      "img" => unit.img,
      "unit_type_id" => unit.unit_type_id,
      "unit_id" => unit.unit_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, unit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, unit_path(conn, :create), unit: valid_attrs
    assert json_response(conn, 201)["unit"]["id"]
    assert Repo.get_by(Unit, valid_attrs)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, unit_path(conn, :create), unit: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    unit = Repo.insert! %Unit{}
    conn = put conn, unit_path(conn, :update, unit), unit: valid_attrs
    assert json_response(conn, 200)["unit"]["id"]
    assert Repo.get_by(Unit, valid_attrs)
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
