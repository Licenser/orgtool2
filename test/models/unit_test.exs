defmodule OrgtoolDb.UnitTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.Unit

  @valid_attrs %{color: "some content", description: "some content", img: "some content", name: "some content", parent: 42, type: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Unit.changeset(%Unit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Unit.changeset(%Unit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
