defmodule OrgtoolDb.CategoryView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{categorys: categorys}) do
    %{categories: render_many(categorys, OrgtoolDb.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{category: render_one(category, OrgtoolDb.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      name: category.name,
      img: category.img}
  end
end
