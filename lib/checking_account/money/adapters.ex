defmodule CheckingAccount.Money.Adapters do
  def to_money(value) do
    (value * 100)
    |> Kernel.trunc()
  end

  def from_money(value) do
    value / 100
  end

  def to_string(value) do
    {integer, cents} =
      value
      |> Integer.to_charlist()
      |> Enum.split(-2)

    [integer, cents]
    |> Enum.join(",")
  end
end
