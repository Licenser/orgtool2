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
alias OrgtoolDb.Member
alias OrgtoolDb.Handle


# Initial member
admin = Repo.insert! %Member{
  name: "Admin",
  avatar: "",
  timezone: 0
}

Repo.insert! %Handle{
  type: "rsi",
  name: "Administrator",
  handle: "admin",
  img: "",
  member: admin
}
