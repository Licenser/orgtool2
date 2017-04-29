alias OrgtoolDb.Repo
alias OrgtoolDb.UnitType
alias OrgtoolDb.Unit

org = Repo.insert! %UnitType{
  name: "org",
  description: "Org",
  img: "",
  ordering: 1
}

game = Repo.insert! %UnitType{
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


# Initial main org and game
some_org = Repo.insert! %Unit{
  name: "Some Org",
  unit_type: org,
}

Repo.insert! %Unit{
  name: "Star Citizen",
  description: "BDSSE",
  color: "#0000cc",
  img: "https://upload.wikimedia.org/wikipedia/en/9/91/Star_Citizen_logo.png",
  unit_type: game,
  unit: some_org
}
