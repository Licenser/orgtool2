defmodule OrgtoolDb.AuthController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.UserFromAuth

  require Logger

  plug Ueberauth

  def login(conn, _params, current_user, _claims) do
    render conn, "login.html", current_user: current_user, current_auths: auths(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user, current_auths: auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case UserFromAuth.get_or_insert(auth, current_user, Repo) do
      {:ok, user} ->
        perms = get_perms(user)
        :io.format("perms: ~p~n", [perms])

        conn
        |> Guardian.Plug.sign_in(user, :access, perms: perms)
        |> redirect(to: "/")
      # |> redirect(to: private_page_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not authenticate. Error: #{reason}")
        |> render("login.html", current_user: current_user, current_auths: auths(current_user))
    end
  end

  def get_perms(user) do
    user = user
    |> Repo.preload(:permission)
    case user.permission do
      nil ->
        %{};
      permission ->
        Logger.info "permissions: #{inspect permission}"
        apply_perms(%{}, :default, permission, [:active], [:active])
        |> apply_perms(:user, permission,
      [:user_read, :user_create, :user_edit, :user_delete],
      [:read,      :create,      :edit,      :delete])
      |> apply_perms(:player, permission,
      [:player_read, :player_create, :player_edit, :player_delete],
      [:read,        :create,        :edit,        :delete])
      |> apply_perms(:unit, permission,
      [:unit_read, :unit_create, :unit_edit, :unit_delete, :unit_assign, :unit_accept, :unit_apply],
      [:read,      :create,      :edit,      :delete,       :assign,      :accept,      :apply])
      |> apply_perms(:category, permission,
      [:category_read, :category_create, :category_edit, :category_delete],
      [:read,          :create,          :edit,          :delete])
      |> apply_perms(:template, permission,
      [:template_read, :template_create, :template_edit, :template_delete],
      [:read,          :create,          :edit,          :delete])
      |> apply_perms(:item, permission,
      [:item_read, :item_create, :item_edit, :item_delete],
      [:read,      :create,      :edit,      :delete])
      |> apply_perms(:reward, permission,
      [:reward_read, :reward_create, :reward_edit, :reward_delete],
      [:read,          :create,          :edit,          :delete])
    end
  end

  def apply_perms(acc, key, perms, src, target) do
    res = get_values(src, target, perms, [])
    Map.put(acc, key, res)
  end

  def get_values([], [], _perms, acc) do
    acc
  end

  def get_values([src | s_rest], [target | t_rest], perms, acc) do
    acc = case Map.get(perms, src) do
            true ->
              [target | acc]
            false ->
              acc
          end
    get_values(s_rest, t_rest, perms, acc)
  end

  def logout(conn, _params, current_user, _claims) do
    if current_user do
      conn
      # This clears the whole session.
      # We could use sign_out(:default) to just revoke this token
      # but I prefer to clear out the session. This means that because we
      # use tokens in two locations - :default and :admin - we need to load it (see above)
      |> Guardian.Plug.sign_out
      |> put_flash(:info, "Signed out")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:info, "Not logged in")
      |> redirect(to: "/")
    end
  end

  defp auths(nil), do: []
  defp auths(%OrgtoolDb.User{} = user) do
    user = user |> Repo.preload(:authorizations)
    user.authorizations
    |> Enum.map(&(&1.provider))
  end
end
