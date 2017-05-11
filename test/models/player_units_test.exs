defmodule OrgtoolDb.PlayerUnitTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.PlayerUnit

  @valid_attrs %{log: "some content", player_id: 42, unit_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PlayerUnit.changeset(%PlayerUnit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PlayerUnit.changeset(%PlayerUnit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
