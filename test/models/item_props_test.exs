defmodule OrgtoolDb.ItemPropsTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.ItemProps

  @valid_attrs %{item: 42, prop: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ItemProps.changeset(%ItemProps{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ItemProps.changeset(%ItemProps{}, @invalid_attrs)
    refute changeset.valid?
  end
end
