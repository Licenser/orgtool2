defmodule OrgtoolDb.RewardTypeControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.RewardType
  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, reward_type_path(conn, :index)
    assert json_response(conn, 200)["reward_types"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    reward_type = Repo.insert! %RewardType{}
    conn = get conn, reward_type_path(conn, :show, reward_type)
    assert json_response(conn, 200)["reward_type"] == %{"id" => reward_type.id,
      "name" => reward_type.name,
      "description" => reward_type.description,
      "img" => reward_type.img,
      "level" => reward_type.level}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, reward_type_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, reward_type_path(conn, :create), reward_type: @valid_attrs
    assert json_response(conn, 201)["reward_type"]["id"]
    assert Repo.get_by(RewardType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, reward_type_path(conn, :create), reward_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    reward_type = Repo.insert! %RewardType{}
    conn = put conn, reward_type_path(conn, :update, reward_type), reward_type: @valid_attrs
    assert json_response(conn, 200)["reward_type"]["id"]
    assert Repo.get_by(RewardType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    reward_type = Repo.insert! %RewardType{}
    conn = put conn, reward_type_path(conn, :update, reward_type), reward_type: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    reward_type = Repo.insert! %RewardType{}
    conn = delete conn, reward_type_path(conn, :delete, reward_type)
    assert response(conn, 204)
    refute Repo.get(RewardType, reward_type.id)
  end
end
