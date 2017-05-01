defmodule OrgtoolDb.TemplatePropView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{template_props: template_props}) do
    %{data: render_many(template_props, OrgtoolDb.TemplatePropView, "template_prop.json")}
  end

  def render("show.json", %{template_prop: template_prop}) do
    %{data: render_one(template_prop, OrgtoolDb.TemplatePropView, "template_prop.json")}
  end

  def render("template_prop.json", %{template_prop: template_prop}) do
    %{id: template_prop.id,
      name: template_prop.name,
      value: template_prop.value,
      template_id: template_prop.template_id}
  end
end
