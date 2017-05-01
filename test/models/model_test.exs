defmodule OrgtoolDb.ModelTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.Model

  @valid_attrs %{description: "some content", img: "some content", category_id: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Model.changeset(%Model{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Model.changeset(%Model{}, @invalid_attrs)
    refute changeset.valid?
  end
end
