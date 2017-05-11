defmodule OrgtoolDb.LeaderUnitTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.LeaderUnit

  @valid_attrs %{player_id: 42, unit_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LeaderUnit.changeset(%LeaderUnit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LeaderUnit.changeset(%LeaderUnit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
