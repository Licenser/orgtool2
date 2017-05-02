defmodule OrgtoolDb.RewardControllerTest do
  use OrgtoolDb.ConnCase, async: false

  alias OrgtoolDb.Reward
  alias OrgtoolDb.RewardType
  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, reward_type} = %RewardType{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :reward_type_id, reward_type.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, reward_path(conn, :index)
    assert json_response(conn, 200)["rewards"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = get conn, reward_path(conn, :show, reward)
    assert json_response(conn, 200)["reward"] == %{"id" => reward.id,
      "description" => reward.description,
      "img" => reward.img,
      "level" => reward.level,
      "name" => reward.name,
      "reward_type_id" => reward.reward_type_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, reward_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, reward_path(conn, :create), reward: valid_attrs
    assert json_response(conn, 201)["reward"]["id"]
    assert Repo.get_by(Reward, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, reward_path(conn, :create), reward: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    reward = Repo.insert! %Reward{}
    conn = put conn, reward_path(conn, :update, reward), reward: valid_attrs
    assert json_response(conn, 200)["reward"]["id"]
    assert Repo.get_by(Reward, valid_attrs)
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
