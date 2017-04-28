# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OrgtoolDb.Repo.insert!(%OrgtoolDb.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OrgtoolDb.Repo
alias OrgtoolDb.ItemType
alias OrgtoolDb.Item
alias OrgtoolDb.Reward
alias OrgtoolDb.Unit
alias OrgtoolDb.UnitType
alias OrgtoolDb.Member
alias OrgtoolDb.Handle

Repo.insert! %ItemType{
  typeName: "manufacturer",
  name: "Manufacturer",
  permissions: 0
}

Repo.insert! %ItemType{
  typeName: "shipModel",
  name: "Ship Model",
  permissions: 0
}

Repo.insert! %ItemType{
  typeName: "ship",
  name: "Ship",
  permissions: 1
}


Repo.insert! %Item{
  name: "RSI",
  type: 1,
  img: "https://robertsspaceindustries.com/media/tb6ui8j38wwscr/icon/RSI.png"

}

Repo.insert! %Item{
  name: "Aurora ES",
  img: "https://robertsspaceindustries.com/media/9u8061zhf29fir/store_large/Rsi_aurora_es_storefront_visual.jpg",
  type: 2,
  parent: 1,
}

Repo.insert! %Item{
  name: "Aurora LX",
  img: "https://robertsspaceindustries.com/media/xfq27owiysn6ar/store_large/Aurora-LX_Ortho.jpg",
  type: 2,
  parent: 1,
}


Repo.insert! %Reward{
  type: 1,
  name: "General",
  level: 1
}
Repo.insert! %Reward{
  type: 1,
  name: "Officer",
  level: 2
}

Repo.insert! %Reward{
  type: 1,
  name: "Deputy Officer",
  level: 3
}
Repo.insert! %Reward{
  type: 1,
  name: "Member",
  level: 4
}
Repo.insert! %Reward{
  type: 1,
  name: "Node Officer",
  description: "Node officer for Black Desert Online",
  level: 3
}
Repo.insert! %Reward{
  type: 2,
  name: "Leader",
  level: 1
}

Repo.insert! %Reward{
  type: 2,
  name: "Member",
  level: 2
}

Repo.insert! %Reward{
  type: 2,
  name: "Applicant",
  level: 3
}

Repo.insert! %Reward{
  type: 3,
  name: "Command",
  level: 1
}


Repo.insert! %UnitType{
  name: "org",
  description: "Org",
  img: "",
  ordering: 1
}
Repo.insert! %UnitType{
  name: "game",
  description: "Games",
  img: "",
  ordering: 2
}
Repo.insert! %UnitType{
  name: "division",
  description: "Devision",
  img: "",
  ordering: 3
}
Repo.insert! %UnitType{
  name: "branch",
  description: "Games",
  img: "",
  ordering: 4,
}
Repo.insert! %UnitType{
  name: "fleet",
  description: "Games",
  img: "",
  ordering: 5,
}
Repo.insert! %UnitType{
  name: "unit",
  description: "Unit",
  img: "",
  ordering: 7
}
Repo.insert! %UnitType{
  name: "squadron",
  description: "Squadron",
  img: "",
  ordering: 7

}

Repo.insert! %Unit{
  name: "Oddysee",
  description: "",
  img: "https://www.oddysee.org/wp-content/plugins/orgtool-wordpress-plugin/orgtool/dist/oddysee-logo-glow.png",
  type: 1,
}

Repo.insert! %Unit{
  name: "Star Citizen",
  description: "BDSSE",
  color: "#0000cc",
  img: "https://upload.wikimedia.org/wikipedia/en/9/91/Star_Citizen_logo.png",
  type: 2,
  parent: 1
}

Repo.insert! %Member{
  name: "Alasmon Necrithious",
  avatar: "https://robertsspaceindustries.com/media/xgf6b8j2ji9l9r/avatar/SC.jpg",
  timezone: 10
}

Repo.insert! %Handle{
  type: "rsi",
  name: "Alasmon Necrithious",
  handle: "Cykhat",
  img: "https://robertsspaceindustries.com/media/xgf6b8j2ji9l9r/avatar/SC.jpg",
  member: 1
}
