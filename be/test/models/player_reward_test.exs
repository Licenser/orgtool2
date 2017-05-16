defmodule OrgtoolDb.PlayerRewardTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.PlayerReward

  @valid_attrs %{player_id: 42, reward_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlayerReward.changeset(%PlayerReward{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlayerReward.changeset(%PlayerReward{}, @invalid_attrs)
    refute changeset.valid?
  end
end
