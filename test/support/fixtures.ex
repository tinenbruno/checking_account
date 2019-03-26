defmodule CheckingAccount.Fixtures do
  alias CheckingAccount.Accounts

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
end
