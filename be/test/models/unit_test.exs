defmodule OrgtoolDb.UnitTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Unit

  @valid_attrs %{color: "some content", description: "some content", img: "some content", name: "some content", unit_id: 42, unit_type_id: 42}
  #@invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Unit.changeset(%Unit{}, @valid_attrs)
    assert changeset.valid?
  end

  ## We can create units w/o content
  # test "changeset with invalid attributes" do
  #   changeset = Unit.changeset(%Unit{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
