defmodule OrgtoolDb.RewardTypesTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.RewardTypes

  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RewardTypes.changeset(%RewardTypes{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RewardTypes.changeset(%RewardTypes{}, @invalid_attrs)
    refute changeset.valid?
  end
end
