defmodule OrgtoolDb.RewardTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Reward

  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content", reward_type_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Reward.changeset(%Reward{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Reward.changeset(%Reward{}, @invalid_attrs)
    refute changeset.valid?
  end
end
