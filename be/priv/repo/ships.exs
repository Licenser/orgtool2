alias OrgtoolDb.Repo
alias OrgtoolDb.ShipModel
require Logger
require Ecto.Query
import Ecto.Query, only: [from: 2]

import SweetXml

response = HTTPotion.post 'https://robertsspaceindustries.com/api/store/getShips', [body: "storefront=pledge&pagesize=255&page=0", headers: ["Content-Type": "application/x-www-form-urlencoded"]]
response.body

%{"data" =>  %{"html" => html}} = Poison.Parser.parse!(response.body)
html = String.replace(html, "Search & Rescue", "Search &amp; Rescue") |> String.replace("Prospecting & Mining", "Prospecting &amp; Mining")

# add l for map
element = html |> xpath(~x'//li[@class="ship-item"]'l,
  ship_id: ~x"@data-ship-id"i,
  img: ~x"./div[@class='center']/img/@src"s,
  name: ~x"./div[@class='center']/a[@class='filet']/span/text()"s,
  class: ~x"./div[@class='center']/a[@class='filet']/span/span/text()"s  |> transform_by(fn name ->
    String.replace(name, ~r/.* - /, "")
  end),
  mname: ~x"./div[last()]/span/img/@src"s |> transform_by(fn name -> :filename.rootname(:filename.basename(name)) end),
  crew: ~x"./div[last()]/span[@class='crew spec']/span/text()"s,
  length: ~x"./div[last()]/span[@class='length spec']/span/text()"s,
  mass: ~x"./div[last()]/span[@class='mass spec']/span/text()"s
)


img_pfx = "https://robertsspaceindustries.com"


to_i = fn (str) ->
  try do
    String.to_integer(str)
  rescue
    _ -> 0
  end
end

to_f = fn (str) ->
  try do
    String.to_float(str)
  rescue
    _ ->
      try do
        String.to_integer(str) + 0.0
      rescue
        _ -> 0.0
      end
  end
end


for %{
      name: name,
      img: img,
      ship_id: ship_id,
      class: class,
      mname: category,
      crew: crew,
      length: length,
      mass: mass
}  <- element do

  crew = to_i.(crew)
  length = to_f.(length)
  mass = to_f.(mass)
  case Repo.one(from m in ShipModel,
        where: m.ship_id == ^ship_id,
        limit: 1) do
    nil ->
      Logger.info("Adding ship #{name}")
      Repo.insert! %ShipModel{
        name: "#{name}",
        img: "#{img_pfx}#{img}",
        manufacturer: category,
        ship_id: ship_id,
        class: class,
        crew: crew,
        length: length,
        mass: mass
      }
    tpl ->
      changes = %{name: "#{name}",
                  img: "#{img_pfx}#{img}",
                  manufacturer: category,
                  ship_id: ship_id,
                  class: class,
                  crew: crew,
                  length: length,
                  mass: mass
                 }
      ShipModel.changeset(tpl, changes)
      |> Repo.update!
  end
end
