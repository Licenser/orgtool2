defmodule OrgtoolDb.Handle do
  use OrgtoolDb.Web, :model

  schema "handles" do
    field :name, :string
    field :handle, :string
    field :img, :string
    field :login, :string
    field :type, :string

    belongs_to :member, OrgtoolDb.Member

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :handle, :img, :login, :member_id])
    |> validate_required([:name, :handle, :img, :login, :member_id])
  end
end
