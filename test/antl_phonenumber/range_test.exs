defmodule AntlPhonenumber.RangeTest do
  use AntlPhonenumber.Case
  import AntlPhonenumber, only: [move: 2, move: 3]
  alias AntlPhonenumber.Range

  describe "new/3" do
    test "builds a range" do
      country_code = country_code()

      first = plus_e164(country_code)
      last = move(first, 10)

      assert %Range{first: ^first, last: ^last, country_code: ^country_code} =
               Range.new(first, last, country_code)
    end

    test "with local numbers" do
      country_code = country_code()

      first = local_number(country_code)
      last = move(first, country_code, 10)

      assert %Range{} = range = Range.new(first, last, country_code)
      assert range.first == AntlPhonenumber.plus_e164!(first, country_code)
      assert range.last == AntlPhonenumber.plus_e164!(last, country_code)
      assert range.country_code == country_code
    end

    test "raises when first and last does not belongs to the same country" do
      first = plus_e164("FR")
      last = plus_e164("BE")

      message =
        "ranges (first..last) expect both sides to have the same contry_code, " <>
          "got: \"#{first}\"..\"#{last}\""

      assert_raise ArgumentError, message, fn -> Range.new(first, last, country_code()) end
    end
  end

  test "inspect" do
    country_code = country_code()

    first = plus_e164(country_code)
    last = move(first, 10)

    assert Range.new(first, last, country_code) |> inspect() == "#{first}..#{last}"

    first = local_number(country_code)
    last = move(first, country_code, 10)

    assert Range.new(first, last, country_code) |> inspect() ==
             "#{first |> AntlPhonenumber.plus_e164!(country_code)}..#{last |> AntlPhonenumber.plus_e164!(country_code)}"
  end

  describe "Enumerable" do
    test "ascendant range" do
      country_code = country_code()
      first = plus_e164(country_code)
      last = move(first, 3)

      # empty?
      refute Range.new(first, last, country_code) |> Enum.empty?()

      # member?
      assert Range.new(first, last, country_code) |> Enum.member?(move(first, 2))
      refute Range.new(first, last, country_code) |> Enum.member?(move(first, 10))

      # count
      assert Range.new(first, last, country_code) |> Enum.count() == 4

      # reduce
      assert Range.new(first, last, country_code)
             |> Enum.map(&AntlPhonenumber.localize/1) == [
               AntlPhonenumber.localize(first),
               AntlPhonenumber.localize(move(first, 1)),
               AntlPhonenumber.localize(move(first, 2)),
               AntlPhonenumber.localize(move(first, 3))
             ]
    end

    test "descendant range" do
      country_code = country_code()
      first = plus_e164(country_code)
      last = move(first, 3)

      # empty?
      refute Range.new(last, first, country_code) |> Enum.empty?()

      # member?
      assert Range.new(last, first, country_code) |> Enum.member?(move(first, 2))
      refute Range.new(last, first, country_code) |> Enum.member?(move(first, 10))

      # count
      assert Range.new(last, first, country_code) |> Enum.count() == 4

      # reduce
      assert Range.new(last, first, country_code)
             |> Enum.map(&AntlPhonenumber.localize/1) == [
               AntlPhonenumber.localize(move(first, 3)),
               AntlPhonenumber.localize(move(first, 2)),
               AntlPhonenumber.localize(move(first, 1)),
               AntlPhonenumber.localize(first)
             ]
    end
  end
end
