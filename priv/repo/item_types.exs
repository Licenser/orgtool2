alias OrgtoolDb.Repo
alias OrgtoolDb.ItemType

Repo.insert! %ItemType{
  type_name: "manufacturer",
  name: "Manufacturer",
  permissions: 0
}

Repo.insert! %ItemType{
  type_name: "shipModel",
  name: "Ship Model",
  permissions: 0
}

Repo.insert! %ItemType{
  type_name: "ship",
  name: "Ship",
  permissions: 1
}