defmodule CheckingAccount.Operations.AdaptersTest do
  use CheckingAccount.DataCase

  describe "adapter" do
    alias CheckingAccount.Operations.Adapters

    test "to_financial_transaction/2 adapts params to transaction attrs" do
      assert Adapters.to_financial_transaction(%{"description" => "description"}, "credit") ==
               %{
                 description: "description",
                 kind: "credit"
               }
    end

    test "to_accouting_entry/2 adapts params to accouting entry attrs" do
      assert Adapters.to_accounting_entry(
               %{"amount" => 123, "destination_account_id" => 1},
               :destination
             ) ==
               %{
                 amount: 12300,
                 currency: "BRL",
                 bank_account_id: 1
               }
    end
  end
end
