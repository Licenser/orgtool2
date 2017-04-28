defmodule OrgtoolDb.RewardControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Reward
  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content", type: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, reward_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = get conn, reward_path(conn, :show, reward)
    assert json_response(conn, 200)["data"] == %{"id" => reward.id,
      "description" => reward.description,
      "img" => reward.img,
      "level" => reward.level,
      "name" => reward.name,
      "type" => reward.type}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, reward_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, reward_path(conn, :create), reward: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Reward, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, reward_path(conn, :create), reward: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = put conn, reward_path(conn, :update, reward), reward: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Reward, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = put conn, reward_path(conn, :update, reward), reward: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = delete conn, reward_path(conn, :delete, reward)
    assert response(conn, 204)
    refute Repo.get(Reward, reward.id)
  end
end
