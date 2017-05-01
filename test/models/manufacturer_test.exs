defmodule OrgtoolDb.ManufacturerTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.Manufacturer

  @valid_attrs %{img: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Manufacturer.changeset(%Manufacturer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Manufacturer.changeset(%Manufacturer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
