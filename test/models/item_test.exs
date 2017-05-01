defmodule OrgtoolDb.ItemTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Item

  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", member: 42, name: "some content", parent: 42, type: 42, unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Item.changeset(%Item{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Item.changeset(%Item{}, @invalid_attrs)
    refute changeset.valid?
  end
end
