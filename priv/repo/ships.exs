alias OrgtoolDb.Repo
alias OrgtoolDb.Item
alias OrgtoolDb.Prop
require Logger

import SweetXml

response = HTTPotion.post 'https://robertsspaceindustries.com/api/store/getShips', [body: "storefront=pledge&pagesize=255&page=0", headers: ["Content-Type": "application/x-www-form-urlencoded"]]
response.body

%{"data" => data = %{"html" => html}} = Poison.Parser.parse!(response.body)
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

rsi = Repo.insert! %Item{
  name: "RSI",
  item_type_id: 1,
  img: "https://robertsspaceindustries.com/media/tb6ui8j38wwscr/icon/RSI.png"
}

for %{
      name: name,
      img: img,
      ship_id: ship_id,
      class: class,
      mname: manufacturer,
      crew: crew,
      length: length,
      mass: mass
}  <- element do
  Repo.insert! %Item{
    name: "#{name}",
    img: "https://robertsspaceindustries.com/#{img}",
    item_type_id: 2,
    item: rsi,
    props: [
      %Prop{
        name: "ship_id",
        value: ship_id
      },
      %Prop{
        name: "name",
        value: name
      },
      %Prop{
        name: "class",
        value: class
      },
      %Prop{
        name: "manufacturer",
        value: manufacturer
      },
      %Prop{
        name: "crew",
        value: crew
      },
      %Prop{
        name: "length",
        value: length
      },
      %Prop{
        name: "mass",
        value: mass
      }
    ]
  }


end
