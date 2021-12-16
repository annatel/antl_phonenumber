defmodule AntlPhonenumber.Factory do
  @default_country_code "IL"
  @default_type :mobile

  def plus_e164(country_code \\ @default_country_code, type \\ @default_type),
    do: AntlPhonenumber.get_plus_e164_example(country_code, type)

  def truncate(number, size \\ 2),
    do: String.slice(number, 0..(String.length(number) - size))

  def local_number(country_code \\ @default_country_code, type \\ @default_type),
    do: AntlPhonenumber.get_plus_e164_example(country_code, type) |> AntlPhonenumber.localize()

  def not_number(), do: "eeeee"

  def country_code(), do: Enum.random(["IL", "FR"])

  @spec type :: any
  def type(), do: AntlPhonenumber.supported_types() |> Enum.random()
end
