defmodule OrgtoolDb.TemplateView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{templates: templates}) do
    %{templates: render_many(templates, OrgtoolDb.TemplateView, "template.json")}
  end

  def render("show.json", %{template: template}) do
    %{template: render_one(template, OrgtoolDb.TemplateView, "template.json")}
  end

  def render("template.json", %{template: template}) do
    %{id: template.id,
      name: template.name,
      img: template.img,
      description: template.description,
      category_id: template.category_id}
  end
end
