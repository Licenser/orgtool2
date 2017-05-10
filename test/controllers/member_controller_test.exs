defmodule OrgtoolDb.MemberControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Member
  @valid_attrs %{avatar: "some content", name: "some content", timezone: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, member_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    member = Repo.insert! %Member{}
    conn = get conn, member_path(conn, :show, member)
    assert json_response(conn, 200)["data"] == %{
      "id" => Integer.to_string(member.id),
      "type" => "member",
      "attributes" => %{
        "name" => member.name,
        "avatar" => member.avatar,
        "timezone" => member.timezone
      },
      "relationships" => %{
        "applications" => %{"data" => []},
        "handles" => %{"data" => []},
        "leaderships" => %{"data" => []},
        "memberships" => %{"data" => []},
        "rewards" => %{"data" => []},
        "items" =>  %{"data" => []},
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, member_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, member_path(conn, :create), data: %{"attributes" => @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Member, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, member_path(conn, :create), data: %{"attributes" => @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    member = Repo.insert! %Member{}
    conn = put conn, member_path(conn, :update, member), id: member.id, data: %{"attributes" => @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Member, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    member = Repo.insert! %Member{}
    conn = put conn, member_path(conn, :update, member),  id: member.id, data: %{"attributes" => @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    member = Repo.insert! %Member{}
    conn = delete conn, member_path(conn, :delete, member)
    assert response(conn, 204)
    refute Repo.get(Member, member.id)
  end
end
