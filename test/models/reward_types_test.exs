defmodule OrgtoolDb.RewardTypeTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.RewardType

  @valid_attrs %{description: "some content", img: "some content", level: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RewardType.changeset(%RewardType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RewardType.changeset(%RewardType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
