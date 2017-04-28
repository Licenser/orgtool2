defmodule OrgtoolDb.ItemTypeTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.ItemType

  @valid_attrs %{description: "some content", img: "some content", name: "some content", permissions: 42, typeName: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ItemType.changeset(%ItemType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ItemType.changeset(%ItemType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
