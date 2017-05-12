defmodule OrgtoolDb.AuthController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use OrgtoolDb.Web, :controller

  alias OrgtoolDb.UserFromAuth

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
        |> redirect(to: "/ui")
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

        apply_perms(
          [:item_read, :item_create, :item_edit, :item_delete],
          [:read,      :create,      :edit,      :delete],
          :item, permission, %{})
    end
  end

  def apply_perms(src, target, key, perms, acc) do
    res = get_values(src, target, perms, %{})
    Maps.set(acc, key, res)
  end

  def get_values([], [], perms, acc) do
    acc
  end

  def get_values([src | s_rest], [target | t_rest], perms, acc) do
    acc = Maps.put(acc, target, Map.get(perms, src))
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
