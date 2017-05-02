defmodule OrgtoolDb.MemberUnitTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.MemberUnit

  @valid_attrs %{log: "some content", member_id: 42, reward_id: 42, unit_id: 42}
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
