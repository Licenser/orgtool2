alias OrgtoolDb.Repo
alias OrgtoolDb.ShipModel
require Logger
require Ecto.Query
import Ecto.Query, only: [from: 2]

import SweetXml


defmodule Fetcher do
  def fetch(compType) do
    rsi = "https://robertsspaceindustries.com"
    url = "#{rsi}/api/store/getSKUs"

    Logger.info("Fetch type #{compType}")
    response = HTTPotion.post url, [body: "storefront=voyager-direct&pagesize=255&page=0&itemType=skus&type=#{compType}", headers: ["Content-Type": "application/x-www-form-urlencoded"]]
    response.body
    %{"data" =>  %{"html" => html}} = Poison.Parser.parse!(response.body)
    html = String.replace(html, "&", "&amp;")
    html = "<root>#{html}</root>"

    elements = html |> xpath(~x'//div[@class="product-item game trans-02s"]'l,
      comp_id: ~x"./div[@class='info clearfix trans-02s']/a[@class='holosmallbtn add-cart add-cart ty-js-add-to-cart']/@data-sku"i,
      img: ~x"./a/img/@src"s |> transform_by(fn img -> "#{rsi}#{img}" end),
      name: ~x"./div[@class='info clearfix trans-02s']/div[@class='title']/text()"s |> transform_by(fn name -> String.replace(name, ".", "") |> String.trim() end),
      type: ~x"./div[@class='type']/text()"s |> transform_by(fn name -> String.replace(name, ~r/.* - /, "") |> String.trim() end),
    )
  end
end


for %{
      comp_id: comp_id,
      img: img,
      name: name,
      type: type
  }  <- Fetcher.fetch("weapons") do

  Logger.info("- ID #{comp_id} | IMG: #{img} | NAME: #{name} | TYPE: #{type}")
end

for %{
      comp_id: comp_id,
      img: img,
      name: name,
      type: type
  }  <- Fetcher.fetch("components") do

  Logger.info("- ID #{comp_id} | IMG: #{img} | NAME: #{name} | TYPE: #{type}")
end
