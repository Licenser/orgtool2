defmodule OrgtoolDb.ModelControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Model
  @valid_attrs %{description: "some content", img: "some content", category_id: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, model_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    model = Repo.insert! %Model{}
    conn = get conn, model_path(conn, :show, model)
    assert json_response(conn, 200)["data"] == %{"id" => model.id,
      "name" => model.name,
      "img" => model.img,
      "description" => model.description,
      "category_id" => model.category_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, model_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, model_path(conn, :create), model: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Model, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, model_path(conn, :create), model: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    model = Repo.insert! %Model{}
    conn = put conn, model_path(conn, :update, model), model: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Model, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    model = Repo.insert! %Model{}
    conn = put conn, model_path(conn, :update, model), model: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    model = Repo.insert! %Model{}
    conn = delete conn, model_path(conn, :delete, model)
    assert response(conn, 204)
    refute Repo.get(Model, model.id)
  end
end
