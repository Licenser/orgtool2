defmodule OrgtoolDb.PermissionControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Permission
  alias OrgtoolDb.User
  @valid_attrs %{
    active: true,

    user_read: true, user_create: true, user_edit: true, user_delete: true,

    player_read: true, player_create: true, player_edit: true, player_delete: true,

    unit_read: true, unit_create: true, unit_edit: true, unit_delete: true, unit_apply: true, unit_accept: true, unit_assign: true,

    ship_model_read: true, ship_model_create: true, ship_model_edit: true, ship_model_delete: true,
    ship_read: true, ship_create: true, ship_edit: true, ship_delete: true,

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

        "ship_model-read"   => permission.ship_model_read,
        "ship_model-create" => permission.ship_model_create,
        "ship_model-edit"   => permission.ship_model_edit,
        "ship_model-delete" => permission.ship_model_delete,

        "ship-read"   => permission.ship_read,
        "ship-create" => permission.ship_create,
        "ship-edit"   => permission.ship_edit,
        "ship-delete" => permission.ship_delete,

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
