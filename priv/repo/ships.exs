alias OrgtoolDb.Repo
alias OrgtoolDb.ItemType
alias OrgtoolDb.Item
alias OrgtoolDb.PropType
alias OrgtoolDb.Prop
require Logger

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

it_manufacturer = Repo.insert! %ItemType{
  type_name: "manufacturer",
  name: "Manufacturer",
  permissions: 0,

}
it_ship_model = Repo.insert! %ItemType{
  type_name: "shipModel",
  name: "Ship Model",
  permissions: 0,
  item_type: it_manufacturer
}

it_ship = Repo.insert! %ItemType{
  type_name: "ship",
  name: "Ship",
  permissions: 1,
  item_type: it_ship_model
}

rsi = Repo.insert! %Item{
  name: "RSI",
  item_type: it_manufacturer,
  img: "https://robertsspaceindustries.com/media/tb6ui8j38wwscr/icon/RSI.png"
}

stats = Repo.insert! %PropType{
  name: "",
  type_name: "stats"
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
    item_type: it_ship_model,
    item: rsi,
    props: [
      %Prop{
        prop_type: stats,
        name: "ship_id",
        value: ship_id
      },
      %Prop{
        prop_type: stats,
        name: "name",
        value: name
      },
      %Prop{
        prop_type: stats,
        name: "class",
        value: class
      },
      %Prop{
        prop_type: stats,
        name: "manufacturer",
        value: manufacturer
      },
      %Prop{
        prop_type: stats,
        name: "crew",
        value: crew
      },
      %Prop{
        prop_type: stats,
        name: "length",
        value: length
      },
      %Prop{
        prop_type: stats,
        name: "mass",
        value: mass
      }
    ]
  }
end

Repo.insert! %Item{
  name: "Boaty McBoatface",
  item_type: it_ship,
  item_id: 0
}
    
