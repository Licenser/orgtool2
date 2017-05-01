alias OrgtoolDb.Repo
alias OrgtoolDb.Manufacturer
alias OrgtoolDb.Model
alias OrgtoolDb.ModelProp
require Logger
require Ecto.Query

import SweetXml

response = HTTPotion.post 'https://robertsspaceindustries.com/api/store/getShips', [body: "storefront=pledge&pagesize=255&page=0", headers: ["Content-Type": "application/x-www-form-urlencoded"]]
response.body

%{"data" =>  %{"html" => html}} = Poison.Parser.parse!(response.body)
html = String.replace(html, "Search & Rescue", "Search &amp; Rescue") |> String.replace("Prospecting & Mining", "Prospecting &amp; Mining")

# add l for map
element = html |> xpath(~x'//li[@class="ship-item"]'l,
  ship_id: ~x"@data-ship-id"s,
  img: ~x"./div[@class='center']/img/@src"s,
  name: ~x"./div[@class='center']/a[@class='filet']/span/text()"s,
  class: ~x"./div[@class='center']/a[@class='filet']/span/span/text()"s  |> transform_by(fn name ->
    String.replace(name, ~r/.* - /, "")
  end),
  mname: ~x"./div[last()]/span/img/@src"s |> transform_by(fn name -> :filename.rootname(:filename.basename(name)) end),
  ming: ~x"./div[last()]/span/img/@src"s,
  crew: ~x"./div[last()]/span[@class='crew spec']/span/text()"s,
  length: ~x"./div[last()]/span[@class='length spec']/span/text()"s,
  mass: ~x"./div[last()]/span[@class='mass spec']/span/text()"s
)


img_pfx = "https://robertsspaceindustries.com"

for %{
      name: name,
      img: img,
      ship_id: ship_id,
      class: class,
      mname: manufacturer,
      ming: manufacturer_img,
      crew: crew,
      length: length,
      mass: mass
}  <- element do
  parent = case Repo.one(Ecto.Query.from(m in Manufacturer, where: m.name == ^manufacturer, limit: 1)) do
             nil ->
               Repo.insert! %Manufacturer{
                 name: manufacturer,
                 img: "#{img_pfx}#{manufacturer_img}"}
             parent ->
               parent
           end
  Repo.insert! %Model{
    name: "#{name}",
    img: "#{img_pfx}#{img}",
    manufacturer: parent,
    model_props: [
      %ModelProp{
        name: "ship_id",
        value: ship_id
      },
      %ModelProp{
        name: "name",
        value: name
      },
      %ModelProp{
        name: "class",
        value: class
      },
      %ModelProp{
        name: "crew",
        value: crew
      },
      %ModelProp{
        name: "length",
        value: length
      },
      %ModelProp{
        name: "mass",
        value: mass
      }
    ]
  }
end
