defmodule OrgtoolDb.ItemPermControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.ItemPerm
  alias OrgtoolDb.User
  @valid_attrs %{create: true, delete: true, edit: true, read: true}
  # @invalid_attrs %{}
  # @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, user} = %User{} |> Repo.insert
    valid_data = %{
      attributes: @valid_attrs,
      relationships: %{
        user:     %{data: %{type: "user", id: user.id}},
      }
    }
    {:ok, valid_data: valid_data, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, item_perm_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    item_perm = Repo.insert! %ItemPerm{}
    conn = get conn, item_perm_path(conn, :show, item_perm)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(item_perm.id),
      "type"          => "item-perm",
      "relationships" => %{
        "user"       => %{"data" => nil},
      },
      "attributes"    => %{
        "read" => item_perm.read,
        "create" => item_perm.create,
        "edit" => item_perm.edit,
        "delete" => item_perm.delete
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, item_perm_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, item_perm_path(conn, :create), data: valid_data
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ItemPerm, @valid_attrs)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, item_perm_path(conn, :create), data: @invalid_data
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    item_perm = Repo.insert! %ItemPerm{}
    conn = put conn, item_perm_path(conn, :update, item_perm), id: item_perm.id, data: valid_data
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ItemPerm, @valid_attrs)
  end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   item_perm = Repo.insert! %ItemPerm{}
  #   conn = put conn, item_perm_path(conn, :update, item_perm), id: item_perm.id, data: @invalid_data
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "deletes chosen resource", %{conn: conn} do
    item_perm = Repo.insert! %ItemPerm{}
    conn = delete conn, item_perm_path(conn, :delete, item_perm)
    assert response(conn, 204)
    refute Repo.get(ItemPerm, item_perm.id)
  end
end
