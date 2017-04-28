defmodule OrgtoolDb.MemberUnitsTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.MemberUnits

  @valid_attrs %{log: "some content", member: 42, reward: 42, unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MemberUnits.changeset(%MemberUnits{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MemberUnits.changeset(%MemberUnits{}, @invalid_attrs)
    refute changeset.valid?
  end
end
