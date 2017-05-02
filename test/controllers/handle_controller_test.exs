defmodule OrgtoolDb.HandleControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Handle
  alias OrgtoolDb.Member
  @valid_attrs %{handle: "some content", img: "some content", login: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, member} = %Member{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :member_id, member.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, handle_path(conn, :index)
    assert json_response(conn, 200)["handles"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = get conn, handle_path(conn, :show, handle)
    assert json_response(conn, 200)["handle"] == %{"id" => handle.id,
      "name" => handle.name,
      "handle" => handle.handle,
      "img" => handle.img,
      "login" => handle.login,
      "member_id" => handle.member_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, handle_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, handle_path(conn, :create), handle: valid_attrs
    assert json_response(conn, 201)["handle"]["id"]
    assert Repo.get_by(Handle, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, handle_path(conn, :create), handle: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    handle = Repo.insert! %Handle{}
    conn = put conn, handle_path(conn, :update, handle), handle: valid_attrs
    assert json_response(conn, 200)["handle"]["id"]
    assert Repo.get_by(Handle, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = put conn, handle_path(conn, :update, handle), handle: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    handle = Repo.insert! %Handle{}
    conn = delete conn, handle_path(conn, :delete, handle)
    assert response(conn, 204)
    refute Repo.get(Handle, handle.id)
  end
end
