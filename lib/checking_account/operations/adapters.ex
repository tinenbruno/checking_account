defmodule CheckingAccount.Operations.Adapters do
  alias CheckingAccount.Money

  def to_financial_transaction(%{"description" => description}, kind) do
    %{description: description, kind: kind}
  end

  def to_accounting_entry(
        %{"amount" => amount, "destination_account_id" => bank_account_id},
        currency \\ "BRL"
      ) do
    %{
      amount: amount |> Money.Adapters.to_money(),
      currency: currency,
      bank_account_id: bank_account_id
    }
  end
end
