defmodule LibphonenumberAnnatelTest do
  use AntlPhonenumber.Case

  defp test_numbers do
    File.read!("test/annatel_test_numbers.csv")
    |> String.split("\n")
    |> Enum.reject(&(&1 =~ ~r/#/))
    |> Enum.filter(&(&1 =~ ~r/,/))
    |> Enum.map(&(&1 |> String.split(",")))
  end

  defp errors_for([plus_e164, local, country, type]) do
    localized = AntlPhonenumber.to_local(plus_e164)
    plussed = AntlPhonenumber.to_plus_e164!(local, country)
    {:ok, found_type} = AntlPhonenumber.get_type(plus_e164)

    [
      AntlPhonenumber.possible?(plus_e164) || "#{plus_e164} is not possible",
      AntlPhonenumber.possible?(local, country) || "#{local} is not possible",
      AntlPhonenumber.valid?(plus_e164) || "#{plus_e164} is not valid",
      AntlPhonenumber.valid?(local, country) || "#{local} is not valid",
      AntlPhonenumber.plus_e164?(plus_e164) || "#{plus_e164} is not considered plus e164 format",
      localized == local || "#{plus_e164} localizes to #{localized} but #{local} was expected",
      plussed == plus_e164 ||
        "#{local} is converted to e164 as #{plussed} but #{plus_e164} was expected",
      "#{found_type}" == type || "#{plus_e164} is of type #{found_type} but #{type} was expected}"
    ]
    |> Enum.reject(&(&1 == true))
  end

  describe "test that Google's libphonenumber returns data coherent with Annatel's version of libphonenumber" do
    test "validate test_numbers/0 returns coherent content" do
      assert test_numbers() |> length() > 3
      assert test_numbers() |> Enum.find(&(&1 == ["+972555001234", "0555001234", "IL", "mobile"]))
    end

    @tag :annatel_specific
    test "validate" do
      all_errors =
        test_numbers()
        |> Enum.reduce([], fn test_data, previous_errors ->
          previous_errors ++ errors_for(test_data)
        end)

      assert [] = all_errors
    end
  end
end
