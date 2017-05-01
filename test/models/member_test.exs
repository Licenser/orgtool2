defmodule OrgtoolDb.MemberTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.Member

  @valid_attrs %{avatar: "some content", logs: "some content", name: "some content", timezone: 42, updated_at: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Member.changeset(%Member{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Member.changeset(%Member{}, @invalid_attrs)
    refute changeset.valid?
  end
end
