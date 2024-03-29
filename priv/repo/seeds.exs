# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chatter.Repo.insert!(%Chatter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

@doc """
Insert a default account to database
"""
alias Chatter.Repo
alias Chatter.Accounts.User

Repo.get_by(User, email: "123@lmk.com") ||
  Repo.insert!(%User{email: "123@lmk.com", password_hash: "password"})
