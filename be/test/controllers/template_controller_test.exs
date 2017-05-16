defmodule OrgtoolDb.TemplateControllerTest do
  use OrgtoolDb.ConnCase

  alias OrgtoolDb.Template
  alias OrgtoolDb.Category
  @valid_attrs %{description: "some content", img: "some content", name: "some content"}
  @invalid_attrs %{}
  @invalid_data %{attributes: @invalid_attrs}

  setup %{conn: conn} do
    {:ok, category} = %Category{} |> Repo.insert
    valid_data = %{
      attributes: @valid_attrs,
      relationships: %{
        category: %{
          data: %{
            type: "category",
            id:   category.id
          }
        }
      }
    }
    {:ok, %{valid_data: valid_data, conn: put_req_header(conn, "accept", "application/json")}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, template_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    template = Repo.insert! %Template{}
    conn = get conn, template_path(conn, :show, template)
    assert json_response(conn, 200)["data"] == %{
      "id"            => Integer.to_string(template.id),
      "type"          => "template",
      "relationships" => %{
        "category" => %{"data" => nil},
        "template-props" => %{"data" => []},
      },
      "attributes"    => %{
        "name" => template.name,
        "img" => template.img,
        "description" => template.description
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, template_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_data: valid_data} do
    conn = post conn, template_path(conn, :create), data: valid_data
    response = json_response(conn, 201)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["category"]["data"]["id"]
    assert Repo.get_by(Template, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, template_path(conn, :create), data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, valid_data: valid_data} do
    template = Repo.insert! %Template{}
    conn = put conn, template_path(conn, :update, template), id: template.id, data: valid_data
    response = json_response(conn, 200)
    assert response["data"]["id"]
    assert response["data"]["relationships"]["category"]["data"]["id"]

    assert Repo.get_by(Template, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    template = Repo.insert! %Template{}
    conn = put conn, template_path(conn, :update, template), id: template.id, data: @invalid_data
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    template = Repo.insert! %Template{}
    conn = delete conn, template_path(conn, :delete, template)
    assert response(conn, 204)
    refute Repo.get(Template, template.id)
  end
end
