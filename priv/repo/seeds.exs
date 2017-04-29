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
alias OrgtoolDb.Item
alias OrgtoolDb.Reward
alias OrgtoolDb.Unit
alias OrgtoolDb.Member
alias OrgtoolDb.Handle
alias OrgtoolDb.PropType

Repo.insert! %Item{
  name: "RSI",
  item_type_id: 1,
  img: "https://robertsspaceindustries.com/media/tb6ui8j38wwscr/icon/RSI.png"

}

Repo.insert! %Item{
  name: "Aurora ES",
  img: "https://robertsspaceindustries.com/media/9u8061zhf29fir/store_large/Rsi_aurora_es_storefront_visual.jpg",
  item_type_id: 2,
  item_id: 1,
}

Repo.insert! %Item{
  name: "Aurora LX",
  img: "https://robertsspaceindustries.com/media/xfq27owiysn6ar/store_large/Aurora-LX_Ortho.jpg",
  item_type_id: 2,
  item_id: 1,
}


Repo.insert! %Reward{
  reward_type_id: 1,
  name: "General",
  level: 1
}
Repo.insert! %Reward{
  reward_type_id: 1,
  name: "Officer",
  level: 2
}

Repo.insert! %Reward{
  reward_type_id: 1,
  name: "Deputy Officer",
  level: 3
}
Repo.insert! %Reward{
  reward_type_id: 1,
  name: "Member",
  level: 4
}
Repo.insert! %Reward{
  reward_type_id: 1,
  name: "Node Officer",
  description: "Node officer for Black Desert Online",
  level: 3
}

Repo.insert! %Reward{
  reward_type_id: 2,
  name: "Leader",
  level: 1
}

Repo.insert! %Reward{
  reward_type_id: 2,
  name: "Member",
  level: 2
}

Repo.insert! %Reward{
  reward_type_id: 2,
  name: "Applicant",
  level: 3
}

Repo.insert! %Reward{
  reward_type_id: 3,
  name: "Command",
  level: 1
}

# Initial main org and game
Repo.insert! %Unit{
  name: "Some Org",
  description: "",
  img: "",
  unit_type_id: 1,
}

Repo.insert! %Unit{
  name: "Star Citizen",
  description: "BDSSE",
  color: "#0000cc",
  img: "https://upload.wikimedia.org/wikipedia/en/9/91/Star_Citizen_logo.png",
  unit_type_id: 2,
  unit_id: 1
}

# Initial member
Repo.insert! %Member{
  name: "Admin",
  avatar: "",
  timezone: 0
}

Repo.insert! %Handle{
  type: "rsi",
  name: "Administrator",
  handle: "admin",
  img: "",
  member_id: 1
}

Repo.insert! %PropType{
  name: "",
  type_name: "stats"
}


