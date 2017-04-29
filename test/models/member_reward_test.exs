defmodule OrgtoolDb.MemberRewardTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.MemberReward

  @valid_attrs %{member_id: 42, reward_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MemberReward.changeset(%MemberReward{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MemberReward.changeset(%MemberReward{}, @invalid_attrs)
    refute changeset.valid?
  end
end
