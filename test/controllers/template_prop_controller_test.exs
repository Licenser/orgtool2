defmodule OrgtoolDb.TemplatePropControllerTest do
  use OrgtoolDb.ConnCase, async: false

  alias OrgtoolDb.TemplateProp
  alias OrgtoolDb.Template
  @valid_attrs %{name: "some content", value: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, template} = %Template{} |> Repo.insert
    valid_attrs = Map.put(@valid_attrs, :template_id, template.id)
    {:ok, %{valid_attrs: valid_attrs, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, template_prop_path(conn, :index)
    assert json_response(conn, 200)["template_props"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    template_prop = Repo.insert! %TemplateProp{}
    conn = get conn, template_prop_path(conn, :show, template_prop)
    assert json_response(conn, 200)["template_prop"] == %{"id" => template_prop.id,
      "name" => template_prop.name,
      "value" => template_prop.value,
      "template_id" => template_prop.template_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, template_prop_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    conn = post conn, template_prop_path(conn, :create), template_prop: valid_attrs
    assert json_response(conn, 201)["template_prop"]["id"]
    assert Repo.get_by(TemplateProp, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, template_prop_path(conn, :create), template_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_attrs: valid_attrs} do
    template_prop = Repo.insert! %TemplateProp{}
    conn = put conn, template_prop_path(conn, :update, template_prop), template_prop: valid_attrs
    assert json_response(conn, 200)["template_prop"]["id"]
    assert Repo.get_by(TemplateProp, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    template_prop = Repo.insert! %TemplateProp{}
    conn = put conn, template_prop_path(conn, :update, template_prop), template_prop: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    template_prop = Repo.insert! %TemplateProp{}
    conn = delete conn, template_prop_path(conn, :delete, template_prop)
    assert response(conn, 204)
    refute Repo.get(TemplateProp, template_prop.id)
  end
end
