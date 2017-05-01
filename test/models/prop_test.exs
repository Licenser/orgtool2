defmodule OrgtoolDb.PropTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Prop

  @valid_attrs %{description: "some content", img: "some content", item: 42, name: "some content", type: 42, unit: 42, value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Prop.changeset(%Prop{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Prop.changeset(%Prop{}, @invalid_attrs)
    refute changeset.valid?
  end
end
