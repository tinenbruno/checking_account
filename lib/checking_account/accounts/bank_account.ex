defmodule CheckingAccount.Accounts.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckingAccount.Accounts.User

  schema "bank_accounts" do
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [:user_id])
    |> validate_required(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
