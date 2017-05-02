defmodule OrgtoolDb.MemberRewardControllerTest do
  use OrgtoolDb.ConnCase


  alias OrgtoolDb.Member
  alias OrgtoolDb.Reward
  alias OrgtoolDb.MemberReward

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, member} = %Member{} |> Repo.insert
    {:ok, reward} = %Reward{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :member_id, member.id)
    |> Map.put(:reward_id, reward.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, member_reward_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    member_reward = Repo.insert! %MemberReward{}
    conn = get conn, member_reward_path(conn, :show, member_reward)
    assert json_response(conn, 200)["data"] == %{"id" => member_reward.id,
      "reward_id" => member_reward.reward_id,
      "member_id" => member_reward.member_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, member_reward_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, member_reward_path(conn, :create), member_reward: valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(MemberReward, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, member_reward_path(conn, :create), member_reward: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    member_reward = Repo.insert! %MemberReward{}
    conn = put conn, member_reward_path(conn, :update, member_reward), member_reward: valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(MemberReward, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    member_reward = Repo.insert! %MemberReward{}
    conn = put conn, member_reward_path(conn, :update, member_reward), member_reward: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    member_reward = Repo.insert! %MemberReward{}
    conn = delete conn, member_reward_path(conn, :delete, member_reward)
    assert response(conn, 204)
    refute Repo.get(MemberReward, member_reward.id)
  end
end
