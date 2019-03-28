defmodule CheckingAccount.Money.AdaptersTest do
  use CheckingAccount.DataCase

  describe "adapter" do
    alias CheckingAccount.Money.Adapters

    test "to_money/1 adapts number param to money in cents" do
      assert Adapters.to_money(1.23) == 123
    end

    test "from_money/1 adapts number money to float" do
      assert Adapters.from_money(123) == 1.23
    end

    test "to_string/1 adapts number in cents to money string" do
      assert Adapters.to_string(123) == "1,23"
    end
  end
end
