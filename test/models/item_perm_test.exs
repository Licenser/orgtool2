defmodule OrgtoolDb.ItemPermTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.ItemPerm

  @valid_attrs %{create: true, delete: true, edit: true, read: true}
  # @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ItemPerm.changeset(%ItemPerm{}, @valid_attrs)
    assert changeset.valid?
  end

  # test "changeset with invalid attributes" do
  #   changeset = ItemPerm.changeset(%ItemPerm{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
