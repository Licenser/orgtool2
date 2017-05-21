defmodule OrgtoolDb.User do
  use OrgtoolDb.Web, :template

  alias OrgtoolDb.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :is_admin, :boolean
    field :unfold_level, :integer
    has_many :authorizations, OrgtoolDb.Authorization
    belongs_to :player, OrgtoolDb.Player
    has_one :permission, OrgtoolDb.Permission, on_replace: :update

    timestamps()
  end

  @required_fields ~w(email name)a
  @optional_fields ~w(is_admin unfold_level)a

  def registration_changeset(ship_model, params \\ :empty) do
    ship_model
    |>cast(params, ~w(email name)a)
    |> validate_required(@required_fields)
  end

  @doc """
  Creates a changeset based on the `ship_model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(ship_model, params \\ :empty) do
    ship_model
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:permission)
    |> cast_assoc(:player)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end

  def make_admin!(user) do
    user
    |> cast(%{is_admin: true}, ~w(is_admin)a)
    |> Repo.update!
  end
end
