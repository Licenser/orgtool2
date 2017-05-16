defmodule OrgtoolDb.PermissionTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Permission

  @valid_attrs %{create: true, delete: true, edit: true, read: true}
  # @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Permission.changeset(%Permission{}, @valid_attrs)
    assert changeset.valid?
  end

  # test "changeset with invalid attributes" do
  #   changeset = Permission.changeset(%Permission{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
