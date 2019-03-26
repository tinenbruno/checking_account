defmodule CheckingAccount.Fixtures do
  alias CheckingAccount.{Accounts, Operations}

  def user_fixture(attrs \\ %{}) do
    default_attrs = %{name: "some name", password: "some password", username: "some username"}

    {:ok, user} =
      default_attrs
      |> Map.merge(attrs)
      |> Accounts.create_user()

    %{user | password: nil}
  end

  def bank_account_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, bank_account} =
      %{user_id: user.id}
      |> Map.merge(attrs)
      |> Accounts.create_bank_account()

    bank_account
  end

  def financial_transaction_fixture(attrs \\ %{}) do
    default_attrs = %{kind: "transfer"}

    {:ok, financial_transaction} =
      default_attrs
      |> Map.merge(attrs)
      |> Operations.create_financial_transaction()

    financial_transaction
  end

  def accounting_entry_fixture(attrs \\ %{}) do
    transaction = financial_transaction_fixture()
    bank_account = bank_account_fixture()

    default_attrs = %{
      amount: "1205",
      currency: "BRL",
      bank_account_id: bank_account.id,
      financial_transaction_id: transaction.id
    }

    {:ok, accounting_entry} =
      default_attrs
      |> Map.merge(attrs)
      |> Operations.create_accounting_entry()

    accounting_entry
  end
end
