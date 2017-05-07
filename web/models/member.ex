defmodule OrgtoolDb.Member do
  use OrgtoolDb.Web, :template

  schema "members" do
    field :name, :string
    field :avatar, :string
    field :timezone, :integer

    has_many :handles, OrgtoolDb.Handle
    has_one :user, OrgtoolDb.User

    has_many :items, OrgtoolDb.Item

    many_to_many :memberships, OrgtoolDb.Unit, join_through: OrgtoolDb.MemberUnit, on_replace: :delete
    many_to_many :applications, OrgtoolDb.Unit, join_through: OrgtoolDb.ApplicantUnit, on_replace: :delete
    many_to_many :leaderships, OrgtoolDb.Unit, join_through: OrgtoolDb.LeaderUnit, on_replace: :delete

    many_to_many :rewards, OrgtoolDb.Reward, join_through: OrgtoolDb.MemberReward, on_replace: :delete

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :avatar, :timezone])
    |> cast_assoc(:user)
    |> cast_assoc(:items)
    |> cast_assoc(:handles)
    |> cast_assoc(:rewards)
    |> cast_assoc(:applications)
    |> cast_assoc(:memberships)
    |> cast_assoc(:leaderships)

    |> validate_required([:name, :timezone])
  end
end
