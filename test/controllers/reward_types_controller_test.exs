defmodule OrgtoolDb.RewardTypesControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.RewardTypes
  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, reward_types_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    reward_types = Repo.insert! %RewardTypes{}
    conn = get conn, reward_types_path(conn, :show, reward_types)
    assert json_response(conn, 200)["data"] == %{"id" => reward_types.id,
      "name" => reward_types.name,
      "description" => reward_types.description,
      "img" => reward_types.img,
      "level" => reward_types.level}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, reward_types_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, reward_types_path(conn, :create), reward_types: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(RewardTypes, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, reward_types_path(conn, :create), reward_types: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    reward_types = Repo.insert! %RewardTypes{}
    conn = put conn, reward_types_path(conn, :update, reward_types), reward_types: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(RewardTypes, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    reward_types = Repo.insert! %RewardTypes{}
    conn = put conn, reward_types_path(conn, :update, reward_types), reward_types: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    reward_types = Repo.insert! %RewardTypes{}
    conn = delete conn, reward_types_path(conn, :delete, reward_types)
    assert response(conn, 204)
    refute Repo.get(RewardTypes, reward_types.id)
  end
end
