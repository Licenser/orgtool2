defmodule OrgtoolDb.ShipTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Ship

  @valid_attrs %{available: true, description: "some content", hidden: true, img: "some content", player_id: 42, name: "some content", template_id: 42, ship_type_id: 42, unit_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Ship.changeset(%Ship{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Ship.changeset(%Ship{}, @invalid_attrs)
    refute changeset.valid?
  end
end
