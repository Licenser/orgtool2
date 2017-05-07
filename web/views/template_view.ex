defmodule OrgtoolDb.TemplateView do
  use OrgtoolDb.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :img, :description]

  has_one :category,
    serializer: OrgtoolDb.CategoryView,
    include: false,
    identifiers: :always # :when_included

  has_many :template_props,
    serializer: OrgtoolDb.TemplatePropView,
    include: false,
    identifiers: :when_included

#      def templates(struct, conn) do
#        case struct.templates do
#          %Ecto.Association.NotLoaded{} ->
#            struct
#            |> Ecto.assoc(:templates)
#            |> Repo.all
#          other -> other
#        end
#      end

end
