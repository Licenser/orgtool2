defmodule OrgtoolDb.PageController do
  use OrgtoolDb.Web, :controller
  #alias OrgtoolDb.Repo

  defp empty?(val) do
    val == nil or val == ""
  end
  defp providers do
    providers = :proplists.get_value(:providers, Application.fetch_env!(:ueberauth, Ueberauth))
    providers = for {provider, _} <- providers do
      provider = Atom.to_string(provider)
      client_id = System.get_env("#{String.upcase(provider)}_CLIENT_ID")
      client_secret = System.get_env("#{String.upcase(provider)}_CLIENT_SECRET")
      {provider, not empty?(client_id) and not empty?(client_secret)}
    end
    for {provider, true} <- providers do
      provider
    end ++ ["identity"]
  end

  def index(conn, _params, _current_user, _claims) do
    csrf = Plug.CSRFProtection.get_csrf_token;
    jwt = Guardian.Plug.current_token(conn)
    providers = providers()
    conn
    |> put_layout(false)
    |> render("index.html", jwt: jwt, csrf: csrf, providers: providers)
  end
end
