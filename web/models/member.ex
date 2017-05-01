defmodule OrgtoolDb.Member do
  use OrgtoolDb.Web, :model

  schema "members" do
    field :name, :string
    field :avatar, :string
    field :logs, :string
    field :timezone, :integer

    has_many :handles, OrgtoolDb.Handle
    has_one :user, OrgtoolDb.User
    many_to_many :rewards, OrgtoolDb.Reward, join_through: OrgtoolDb.MemberReward, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :avatar, :logs, :timezone])
    |> validate_required([:name, :timezone])
  end
end
