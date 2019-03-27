defmodule CheckingAccount.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckingAccount.Accounts.BankAccount

  schema "users" do
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    field(:username, :string)
    has_one(:bank_account, BankAccount)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
  end

  @doc false
  def creation_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 6)
    |> validate_required([:password])
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
