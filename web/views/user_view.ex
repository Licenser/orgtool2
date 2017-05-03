defmodule OrgtoolDb.UserView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email, :name]

end
