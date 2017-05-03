defmodule OrgtoolDb.LeaderUnitControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.LeaderUnit
  @valid_attrs %{member_id: 42, unit_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, leader_unit_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    leader_unit = Repo.insert! %LeaderUnit{}
    conn = get conn, leader_unit_path(conn, :show, leader_unit)
    assert json_response(conn, 200)["data"] == %{"id" => leader_unit.id,
      "member_id" => leader_unit.member_id,
      "unit_id" => leader_unit.unit_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, leader_unit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, leader_unit_path(conn, :create), leader_unit: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(LeaderUnit, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, leader_unit_path(conn, :create), leader_unit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    leader_unit = Repo.insert! %LeaderUnit{}
    conn = put conn, leader_unit_path(conn, :update, leader_unit), leader_unit: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(LeaderUnit, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    leader_unit = Repo.insert! %LeaderUnit{}
    conn = put conn, leader_unit_path(conn, :update, leader_unit), leader_unit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    leader_unit = Repo.insert! %LeaderUnit{}
    conn = delete conn, leader_unit_path(conn, :delete, leader_unit)
    assert response(conn, 204)
    refute Repo.get(LeaderUnit, leader_unit.id)
  end
end
