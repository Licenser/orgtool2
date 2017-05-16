defmodule OrgtoolDb.TemplatePropTest do
  use OrgtoolDb.TemplateCase

  alias OrgtoolDb.TemplateProp

  @valid_attrs %{template_id: 42, name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TemplateProp.changeset(%TemplateProp{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TemplateProp.changeset(%TemplateProp{}, @invalid_attrs)
    refute changeset.valid?
  end
end
