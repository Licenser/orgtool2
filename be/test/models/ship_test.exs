defmodule OrgtoolDb.ItemTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Item

  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", player_id: 42, name: "some content", template_id: 42, item_type_id: 42, unit_id: 42}
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
