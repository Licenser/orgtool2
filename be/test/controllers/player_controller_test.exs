defmodule OrgtoolDb.PlayerControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Player
  @valid_attrs %{avatar: "some content", name: "some content", timezone: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, player_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = get conn, player_path(conn, :show, player)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(player.id),
      "type" => "player",
      "attributes" => %{
        "name" => player.name,
        "avatar" => player.avatar,
        "timezone" => player.timezone
      },
      "relationships" => %{
        "applications" => %{"data" => []},
        "handles" => %{"data" => []},
        "leaderships" => %{"data" => []},
        "playerships" => %{"data" => []},
        "rewards" => %{"data" => []},
        "ships" =>  %{"data" => []},
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, player_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, player_path(conn, :create), data: %{"attributes" => @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Player, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, player_path(conn, :create), data: %{"attributes" => @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = put conn, player_path(conn, :update, player), id: player.id, data: %{"attributes" => @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Player, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = put conn, player_path(conn, :update, player),  id: player.id, data: %{"attributes" => @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    player = Repo.insert! %Player{}
    conn = delete conn, player_path(conn, :delete, player)
    assert response(conn, 204)
    refute Repo.get(Player, player.id)
  end
end
