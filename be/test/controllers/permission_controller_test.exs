defmodule OrgtoolDb.PermissionControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Permission
  alias OrgtoolDb.User
  @valid_attrs %{
    active: true,

    user_read: true, user_create: true, user_edit: true, user_delete: true,

    player_read: true, player_create: true, player_edit: true, player_delete: true,

    unit_read: true, unit_create: true, unit_edit: true, unit_delete: true, unit_apply: true, unit_accept: true, unit_assign: true,

    category_read: true, category_create: true, category_edit: true, category_delete: true,
    template_read: true, template_create: true, template_edit: true, template_delete: true,
    item_read: true, item_create: true, item_edit: true, item_delete: true,

    reward_read: true, reward_create: true, reward_edit: true, reward_delete: true
  }
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
    conn = get conn, permission_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = get conn, permission_path(conn, :show, permission)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(permission.id),
      "type"          => "permission",
      "relationships" => %{
        "user"       => %{"data" => nil},
      },
      "attributes"    => %{
        "active"      => permission.active,

        "user-read"   => permission.user_read,
        "user-create" => permission.user_create,
        "user-edit"   => permission.user_edit,
        "user-delete" => permission.user_delete,

        "player-read"   => permission.player_read,
        "player-create" => permission.player_create,
        "player-edit"   => permission.player_edit,
        "player-delete" => permission.player_delete,

        "unit-read"   => permission.unit_read,
        "unit-create" => permission.unit_create,
        "unit-edit"   => permission.unit_edit,
        "unit-delete" => permission.unit_delete,
        "unit-apply"  => permission.unit_apply,
        "unit-accept" => permission.unit_accept,
        "unit-assign" => permission.unit_assign,

        "category-read"   => permission.category_read,
        "category-create" => permission.category_create,
        "category-edit"   => permission.category_edit,
        "category-delete" => permission.category_delete,

        "template-read"   => permission.template_read,
        "template-create" => permission.template_create,
        "template-edit"   => permission.template_edit,
        "template-delete" => permission.template_delete,

        "item-read"   => permission.item_read,
        "item-create" => permission.item_create,
        "item-edit"   => permission.item_edit,
        "item-delete" => permission.item_delete,

        "reward-read"   => permission.reward_read,
        "reward-create" => permission.reward_create,
        "reward-edit"   => permission.reward_edit,
        "reward-delete" => permission.reward_delete,
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, permission_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, permission_path(conn, :create), data: valid_data
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, permission_path(conn, :create), data: @invalid_data
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    permission = Repo.insert! %Permission{}
    conn = put conn, permission_path(conn, :update, permission), id: permission.id, data: valid_data
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Permission, @valid_attrs)
  end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   permission = Repo.insert! %Permission{}
  #   conn = put conn, permission_path(conn, :update, permission), id: permission.id, data: @invalid_data
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "deletes chosen resource", %{conn: conn} do
    permission = Repo.insert! %Permission{}
    conn = delete conn, permission_path(conn, :delete, permission)
    assert response(conn, 204)
    refute Repo.get(Permission, permission.id)
  end
end
