defmodule OrgtoolDb.ModelPropControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ModelProp
  @valid_attrs %{model_id: 42, name: "some content", value: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, model_prop_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    model_prop = Repo.insert! %ModelProp{}
    conn = get conn, model_prop_path(conn, :show, model_prop)
    assert json_response(conn, 200)["data"] == %{"id" => model_prop.id,
      "name" => model_prop.name,
      "value" => model_prop.value,
      "model_id" => model_prop.model_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, model_prop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, model_prop_path(conn, :create), model_prop: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ModelProp, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, model_prop_path(conn, :create), model_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    model_prop = Repo.insert! %ModelProp{}
    conn = put conn, model_prop_path(conn, :update, model_prop), model_prop: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ModelProp, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    model_prop = Repo.insert! %ModelProp{}
    conn = put conn, model_prop_path(conn, :update, model_prop), model_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    model_prop = Repo.insert! %ModelProp{}
    conn = delete conn, model_prop_path(conn, :delete, model_prop)
    assert response(conn, 204)
    refute Repo.get(ModelProp, model_prop.id)
  end
end
