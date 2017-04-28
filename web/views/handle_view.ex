defmodule OrgtoolDb.HandleView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{handles: handles}) do
    %{handles: render_many(handles, OrgtoolDb.HandleView, "handle.json")}
  end

  def render("show.json", %{handle: handle}) do
    %{handle: render_one(handle, OrgtoolDb.HandleView, "handle.json")}
  end

  def render("handle.json", %{handle: handle}) do
    %{id: handle.id,
      name: handle.name,
      handle: handle.handle,
      img: handle.img,
      login: handle.login,
      member: handle.member}
  end
end
