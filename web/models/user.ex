defmodule OrgtoolDb.User do
  use OrgtoolDb.Web, :template

  alias OrgtoolDb.Repo

  schema "users" do
    field :name, :string
    field :email, :string
    field :is_admin, :boolean

    has_many :authorizations, OrgtoolDb.Authorization
    belongs_to :member, OrgtoolDb.Member
    has_one :item_perm, OrgtoolDb.ItemPerm

    timestamps()
  end

  @required_fields ~w(email name)a
  @optional_fields ~w(is_admin member)a

  def registration_changeset(template, params \\ :empty) do
    template
    |>cast(params, ~w(email name)a)
    |> validate_required(@required_fields)
  end

  @doc """
  Creates a changeset based on the `template` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(template, params \\ :empty) do
    template
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
  end

  def make_admin!(user) do
    user
    |> cast(%{is_admin: true}, ~w(is_admin)a)
    |> Repo.update!
  end
end
