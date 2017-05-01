defmodule OrgtoolDb.PropTypeTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.PropType

  @valid_attrs %{description: "some content", img: "some content", name: "some content", type_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PropType.changeset(%PropType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PropType.changeset(%PropType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
