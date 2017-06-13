defmodule OrgtoolDb.ModelTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.ShipModel

  @valid_attrs %{description: "some content", img: "some content", name: "some content", ship_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ShipModel.changeset(%ShipModel{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ShipModel.changeset(%ShipModel{}, @invalid_attrs)
    refute changeset.valid?
  end
end
