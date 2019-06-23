defmodule Chatter.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :password_hash, :string # Argon2.add_hash use this field name, so cant change this
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password ])
    |> unique_constraint(:email)
  end

  def reg_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 5)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
