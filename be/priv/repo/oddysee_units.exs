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
div = Repo.insert! %UnitType{
  name: "division",
  description: "Devision",
  img: "",
  ordering: 3
}
branch = Repo.insert! %UnitType{
  name: "branch",
  description: "Branch",
  img: "",
  ordering: 4,
}
fleet = Repo.insert! %UnitType{
  name: "fleet",
  description: "Fleet",
  img: "",
  ordering: 5,
}
unit = Repo.insert! %UnitType{
  name: "unit",
  description: "Unit",
  img: "",
  ordering: 7
}
squad = Repo.insert! %UnitType{
  name: "squadron",
  description: "Squadron",
  img: "",
  ordering: 7
}


# Initial main org and game
odd = Repo.insert! %Unit{
  name: "Oddysee",
  img: "https://www.oddysee.org/wp-content/plugins/orgtool-wordpress-plugin/orgtool/dist/oddysee-logo-glow.png",
  unit_type: org,
}

################################
################################
################################

sc = Repo.insert! %Unit{
  name: "Star Citizen",
  description: "BDSSE",
  color: "#0000cc",
  img: "https://upload.wikimedia.org/wikipedia/en/9/91/Star_Citizen_logo.png",
  unit_type: game,
  unit: odd
}

bd = Repo.insert! %Unit{
  name: "Black Desert Online",
  description: "Oddysee Branch for Black Desert online",
  color: "#2497db",
  img: "http://vignette4.wikia.nocookie.net/blackdesert/images/d/dc/Poll_spirit.png/revision/latest?cb=20151025214147",
  unit_type: game,
  unit: odd
}

arma = Repo.insert! %Unit{
  name: "Arma 3",
  description: "Arma 3",
  color: "#68aa12",
  img: "http://marinesof.com/wp-content/uploads/2016/01/Arma-3-logo.png",
  unit_type: game,
  unit: odd
}

################################
################################
################################


intel = Repo.insert! %Unit{
  name: "Intel",
  description: "Intelligence",
  color: "#222222",
  img: "",
  unit_type: div,
  unit: sc
}

sod = Repo.insert! %Unit{
  name: "SOD",
  description: "Strategic Operations Department",
  color: "#9F0000",
  img: "",
  unit_type: div,
  unit: intel
}

lid = Repo.insert! %Unit{
  name: "LID",
  description: "Logistics and Industrial Division",
  color: "#0000CC",
  img: "",
  unit_type: div,
  unit: intel
}

pf = Repo.insert! %Unit{
  name: "Pathfinder",
  description: "",
  color: "#CCCC55",
  img: "",
  unit_type: div,
  unit: intel
}

pr = Repo.insert! %Unit{
  name: "Public Relations",
  description: "",
  color: "#005500",
  img: "",
  unit_type: div,
  unit: intel
}

################################
################################
################################

fl1 = Repo.insert! %Unit{
  name: "1st Fleet",
  description: "The 1st Battle Fleet",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: sod
}

mar = Repo.insert! %Unit{
  name: "Marines",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: sod
}

################################

lf = Repo.insert! %Unit{
  name: "Light Fighters",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}
hf = Repo.insert! %Unit{
  name: "Heavy Fighters",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}
ab = Repo.insert! %Unit{
  name: "Assault/ Bombers",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}
recon = Repo.insert! %Unit{
  name: "Recon",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}
gt = Repo.insert! %Unit{
  name: "Gunships/ Transports",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}
cap = Repo.insert! %Unit{
  name: "Capital Ships Command",
  description: "",
  color: "#9F0000",
  img: "",
  unit_type: unit,
  unit: fl1
}

################################
################################
################################

cat = Repo.insert! %Unit{
  name: "Cartography",
  description: "",
  color: "#CCCC55",
  img: "",
  unit_type: unit,
  unit: pf
}

nav = Repo.insert! %Unit{
  name: "Navigation",
  description: "",
  color: "#CCCC55",
  img: "",
  unit_type: unit,
  unit: pf
}

op = Repo.insert! %Unit{
  name: "Operations",
  description: "",
  color: "#CCCC55",
  img: "",
  unit_type: unit,
  unit: pf
}

################################
################################
################################

cont = Repo.insert! %Unit{
  name: "Contracts",
  description: "",
  color: "#005500",
  img: "",
  unit_type: unit,
  unit: pr
}
race = Repo.insert! %Unit{
  name: "Racing",
  description: "",
  color: "#005500",
  img: "",
  unit_type: unit,
  unit: pr
}
rec = Repo.insert! %Unit{
  name: "Recruiting",
  description: "",
  color: "#005500",
  img: "",
  unit_type: unit,
  unit: pr
}

################################
################################
################################

salv = Repo.insert! %Unit{
  name: "Tech Salvage",
  description: "",
  color: "#",
  img: "",
  unit_type: unit,
  unit: lid
}

trade = Repo.insert! %Unit{
  name: "Trade Logistics",
  description: "",
  color: "#",
  img: "",
  unit_type: unit,
  unit: lid
}

################################

sa = Repo.insert! %Unit{
  name: "Salvage",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: salv
}
bo = Repo.insert! %Unit{
  name: "Boarding",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: salv
}
te = Repo.insert! %Unit{
  name: "Technology",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: salv
}
ord = Repo.insert! %Unit{
  name: "Ordinance",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: salv
}

################################

tr = Repo.insert! %Unit{
  name: "Trading",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: trade
}
mi = Repo.insert! %Unit{
  name: "Mining",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: trade
}
lo = Repo.insert! %Unit{
  name: "Logistics",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: trade
}
bo = Repo.insert! %Unit{
  name: "Base Operations",
  description: "",
  color: "#0000CC",
  img: "",
  unit_type: unit,
  unit: trade
}

