defmodule OrgtoolDb.ManufacturerControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Manufacturer
  @valid_attrs %{img: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, manufacturer_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    manufacturer = Repo.insert! %Manufacturer{}
    conn = get conn, manufacturer_path(conn, :show, manufacturer)
    assert json_response(conn, 200)["data"] == %{"id" => manufacturer.id,
      "name" => manufacturer.name,
      "img" => manufacturer.img}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, manufacturer_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, manufacturer_path(conn, :create), manufacturer: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Manufacturer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, manufacturer_path(conn, :create), manufacturer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    manufacturer = Repo.insert! %Manufacturer{}
    conn = put conn, manufacturer_path(conn, :update, manufacturer), manufacturer: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Manufacturer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    manufacturer = Repo.insert! %Manufacturer{}
    conn = put conn, manufacturer_path(conn, :update, manufacturer), manufacturer: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    manufacturer = Repo.insert! %Manufacturer{}
    conn = delete conn, manufacturer_path(conn, :delete, manufacturer)
    assert response(conn, 204)
    refute Repo.get(Manufacturer, manufacturer.id)
  end
end
