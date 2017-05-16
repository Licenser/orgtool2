defmodule OrgtoolDb.TemplateTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Template

  @valid_attrs %{description: "some content", img: "some content", category_id: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Template.changeset(%Template{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Template.changeset(%Template{}, @invalid_attrs)
    refute changeset.valid?
  end
end
