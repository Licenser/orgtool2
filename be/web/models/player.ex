defmodule OrgtoolDb.Player do
  use OrgtoolDb.Web, :template

  schema "players" do
    field :name, :string
    field :avatar, :string
    field :timezone, :integer

    has_many :handles, OrgtoolDb.Handle
    has_many :ships, OrgtoolDb.Ship
    has_one :user, OrgtoolDb.User

    many_to_many :playerships, OrgtoolDb.Unit, join_through: OrgtoolDb.PlayerUnit, on_replace: :delete
    many_to_many :applications, OrgtoolDb.Unit, join_through: OrgtoolDb.ApplicantUnit, on_replace: :delete
    many_to_many :leaderships, OrgtoolDb.Unit, join_through: OrgtoolDb.LeaderUnit, on_replace: :delete

    many_to_many :rewards, OrgtoolDb.Reward, join_through: OrgtoolDb.PlayerReward, on_replace: :delete


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :avatar, :timezone])
    |> cast_assoc(:user)
    |> cast_assoc(:handles)
    |> cast_assoc(:rewards)
    |> cast_assoc(:applications)
    |> cast_assoc(:playerships)
    |> cast_assoc(:leaderships)
    |> validate_required([:name, :timezone])
  end
end
