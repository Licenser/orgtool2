defmodule OrgtoolDb.MemberUnitsControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.MemberUnits
  @valid_attrs %{log: "some content", member: 42, reward: 42, unit: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, member_units_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    member_units = Repo.insert! %MemberUnits{}
    conn = get conn, member_units_path(conn, :show, member_units)
    assert json_response(conn, 200)["data"] == %{"id" => member_units.id,
      "log" => member_units.log,
      "member" => member_units.member,
      "reward" => member_units.reward,
      "unit" => member_units.unit}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, member_units_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, member_units_path(conn, :create), member_units: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(MemberUnits, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, member_units_path(conn, :create), member_units: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    member_units = Repo.insert! %MemberUnits{}
    conn = put conn, member_units_path(conn, :update, member_units), member_units: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(MemberUnits, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    member_units = Repo.insert! %MemberUnits{}
    conn = put conn, member_units_path(conn, :update, member_units), member_units: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    member_units = Repo.insert! %MemberUnits{}
    conn = delete conn, member_units_path(conn, :delete, member_units)
    assert response(conn, 204)
    refute Repo.get(MemberUnits, member_units.id)
  end
end
