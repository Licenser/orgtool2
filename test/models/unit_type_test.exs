defmodule OrgtoolDb.UnitTypeTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.UnitType

  @valid_attrs %{description: "some content", img: "some content", name: "some content", ordering: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UnitType.changeset(%UnitType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UnitType.changeset(%UnitType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
