defmodule OrgtoolDb.ModelPropView do
  use OrgtoolDb.Web, :view

  def render("index.json", %{model_props: model_props}) do
    %{data: render_many(model_props, OrgtoolDb.ModelPropView, "model_prop.json")}
  end

  def render("show.json", %{model_prop: model_prop}) do
    %{data: render_one(model_prop, OrgtoolDb.ModelPropView, "model_prop.json")}
  end

  def render("model_prop.json", %{model_prop: model_prop}) do
    %{id: model_prop.id,
      name: model_prop.name,
      value: model_prop.value,
      model_id: model_prop.model_id}
  end
end
