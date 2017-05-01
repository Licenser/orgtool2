defmodule OrgtoolDb.MemberUnitTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.MemberUnit

  @valid_attrs %{log: "some content", member: 42, reward: 42, unit: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MemberUnit.changeset(%MemberUnit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MemberUnit.changeset(%MemberUnit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
