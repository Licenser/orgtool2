defmodule OrgtoolDb.CategoryTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.Category

  @valid_attrs %{img: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
