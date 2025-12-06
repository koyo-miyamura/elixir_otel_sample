# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OtelSample.Repo.insert!(%OtelSample.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OtelSample.Repo
alias OtelSample.Accounts.User

# Create 1000 users
for i <- 1..1000 do
  Repo.insert!(%User{
    name: "User #{i}"
  })
end

IO.puts("Created 1000 users")
