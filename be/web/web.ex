defmodule OrgtoolDb.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

  use OrgtoolDb.Web, :controller
  use OrgtoolDb.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def template do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def admin_controller do
    quote do
      use Phoenix.Controller, namespace: OrgtoolDb.Admin
      use Guardian.Phoenix.Controller, key: :admin

      alias OrgtoolDb.Repo
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]

      import OrgtoolDb.Router.Helpers
      import OrgtoolDb.Controller.Helpers
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      use Guardian.Phoenix.Controller

      alias OrgtoolDb.Repo
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]

      import OrgtoolDb.Router.Helpers
      import OrgtoolDb.Controller.Helpers

      defp same_player?(user, id) do
        user.player_id == id
      end

      defp id_int(b) when is_binary(b) do
        String.to_integer(b)
      end

      defp id_int(b) do
        b
      end

      defp handle_rels(changeset, %{"included" => included,
                                    "data" => %{"relationships" => relationships}}, fun) do
        changeset
        |> fun.(relationships)
        |> fun.(included)
      end

      defp handle_rels(changeset, %{"included" => included}, fun) do
        changeset
        |> fun.(included)
      end
      defp handle_rels(changeset, %{"data" => %{"relationships" => relationships}}, fun) do
        changeset
        |> fun.(relationships)
      end

      defp handle_rels(changeset, _ ,_) do
        changeset
      end

      defp maybe_apply(changeset, model, key, relationships) do
        type = Atom.to_string(key)
        maybe_apply(changeset, model, type, key, relationships)
      end
      defp maybe_apply(changeset, model, type, key, relationships) do
        json_key = type
        maybe_apply(changeset, model, type, json_key, key, relationships)
      end

      defp maybe_apply(changeset, _model, _type, _json_key, _key, []) do
        changeset
      end

      defp maybe_apply(changeset, model, type, json_key, key, [element | elements]) do
        handle_element(element, changeset, model, type, key)
        |> maybe_apply(model, type, json_key, key, elements)
      end

      defp maybe_apply(changeset, model, type, json_key, key, relationships) do
        handle_element(Map.get(relationships, json_key), changeset, model, type, key)
      end

      defp handle_element(element, changeset, model, type, key) do
        case element do
          # This is a dirty hack, maybe we should do this differently?
          %{"type" => ^type, "id" => id, "attributes" => params} ->
            element = case Kernel.function_exported?(model, :changeset_include, 2) do
                        true ->
                          params = JaSerializer.ParamParser.parse(params)
                          element = Repo.get!(model, id_int(id))
                          apply(model, :changeset_include, [element, params])
                        false ->
                          Repo.get!(model, id_int(id))
                      end
            Ecto.Changeset.put_assoc(changeset, key, element)
          %{"data" => %{"type" => ^type, "id" => id}} ->
              element = Repo.get!(model, id_int(id))
              Ecto.Changeset.put_assoc(changeset, key, element)
          %{"data" => nil} ->
              changeset
          %{"data" => elements} ->
              elements = for %{"id" => id, "type" => ^type} <- elements do
                  Repo.get!(model, id_int(id))
                end
              Ecto.Changeset.put_assoc(changeset, key, elements)
          _ ->
              changeset
        end
      end
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import OrgtoolDb.Router.Helpers
      import OrgtoolDb.ErrorHelpers
      import OrgtoolDb.Gettext
      import OrgtoolDb.ViewHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias OrgtoolDb.Repo
      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
