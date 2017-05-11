defmodule OrgtoolDb.ApplicantUnitTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.ApplicantUnit

  @valid_attrs %{player_id: 42, unit_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ApplicantUnit.changeset(%ApplicantUnit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ApplicantUnit.changeset(%ApplicantUnit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
