defmodule OrgtoolDb.MemberUnitControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.MemberUnit
  alias OrgtoolDb.Member
  alias OrgtoolDb.Reward
  alias OrgtoolDb.Unit
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, member} = %Member{} |> Repo.insert
    {:ok, reward} = %Reward{} |> Repo.insert
    {:ok, unit} = %Unit{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :member_id, member.id)
    |> Map.put(:reward_id, reward.id)
    |> Map.put(:unit_id, unit.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, member_unit_path(conn, :index)
    assert json_response(conn, 200)["member_units"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    member_unit = Repo.insert! %MemberUnit{}
    conn = get conn, member_unit_path(conn, :show, member_unit)
    assert json_response(conn, 200)["member_unit"] == %{"id" => member_unit.id,
                                                        "member_id" => member_unit.member_id,
                                                        "reward_id" => member_unit.reward_id,
                                                        "unit_id" => member_unit.unit_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, member_unit_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, member_unit_path(conn, :create), member_unit: valid_attrs
    assert json_response(conn, 201)["member_unit"]["id"]
    assert Repo.get_by(MemberUnit, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, member_unit_path(conn, :create), member_unit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    member_unit = Repo.insert! %MemberUnit{}
    conn = put conn, member_unit_path(conn, :update, member_unit), member_unit: valid_attrs
    assert json_response(conn, 200)["member_unit"]["id"]
    assert Repo.get_by(MemberUnit, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    member_unit = Repo.insert! %MemberUnit{}
    conn = put conn, member_unit_path(conn, :update, member_unit), member_unit: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    member_unit = Repo.insert! %MemberUnit{}
    conn = delete conn, member_unit_path(conn, :delete, member_unit)
    assert response(conn, 204)
    refute Repo.get(MemberUnit, member_unit.id)
  end
end
