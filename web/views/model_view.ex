defmodule OrgtoolDb.ModelView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{models: models}) do
    %{models: render_many(models, OrgtoolDb.ModelView, "model.json")}
  end

  def render("show.json", %{model: model}) do
    %{model: render_one(model, OrgtoolDb.ModelView, "model.json")}
  end

  def render("model.json", %{model: model}) do
    %{id: model.id,
      name: model.name,
      img: model.img,
      description: model.description,
      category_id: model.category_id}
  end
end
