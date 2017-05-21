defmodule OrgtoolDb.ErrorView do
  use OrgtoolDb.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # ship_model is found, let's render it as 500
  def ship_model_not_found(_ship_model, assigns) do
    render "500.html", assigns
  end
end
