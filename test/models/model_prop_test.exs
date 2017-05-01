defmodule OrgtoolDb.ModelPropTest do
  use OrgtoolDb.ModelCase

  alias OrgtoolDb.ModelProp

  @valid_attrs %{model_id: 42, name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ModelProp.changeset(%ModelProp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ModelProp.changeset(%ModelProp{}, @invalid_attrs)
    refute changeset.valid?
  end
end
