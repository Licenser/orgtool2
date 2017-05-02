defmodule OrgtoolDb.ItemPropTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.ItemProp

  @valid_attrs %{item_id: 42, name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ItemProp.changeset(%ItemProp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ItemProp.changeset(%ItemProp{}, @invalid_attrs)
    refute changeset.valid?
  end
end
