defmodule OrgtoolDb.RewardControllerTest do
  use OrgtoolDb.ConnCase, async: false

  alias OrgtoolDb.Reward
  alias OrgtoolDb.RewardType
  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}
  @invalid_data %{
    attributes:    @invalid_attrs,
  }

  setup %{conn: conn} do
    {:ok, reward_type} = %RewardType{} |> Repo.insert
    valid_data = %{
      attributes:    @valid_attrs,
      relationships: %{
        members: %{data: []},
        reward_type: %{data: %{type: "reward_type", id: reward_type.id}}
      }
    }
    {:ok, %{valid_data: valid_data, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, reward_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = get conn, reward_path(conn, :show, reward)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(reward.id),
      "type" => "reward",
      "attributes" => %{
        "description" => reward.description,
        "img" => reward.img,
        "level" => reward.level,
        "name" => reward.name,
      },
      "relationships" => %{
        "reward-type" => %{"data" => nil},
        "members" => %{"data" => []},

      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, reward_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, reward_path(conn, :create), data: valid_data
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Reward, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, reward_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    reward = Repo.insert! %Reward{}
    conn = put conn, reward_path(conn, :update, reward), id: reward.id, data: valid_data
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Reward, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = put conn, reward_path(conn, :update, reward), id: reward.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    reward = Repo.insert! %Reward{}
    conn = delete conn, reward_path(conn, :delete, reward)
    assert response(conn, 204)
    refute Repo.get(Reward, reward.id)
  end
end
