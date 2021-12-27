defmodule AntlPhonenumberTest do
  use AntlPhonenumber.Case

  test "plus_e164?/1" do
    assert plus_e164() |> AntlPhonenumber.plus_e164?()
    refute local_number() |> AntlPhonenumber.plus_e164?()
    refute not_number() |> AntlPhonenumber.plus_e164?()
  end

  test "valid_plus_e164_number?/1" do
    assert plus_e164() |> AntlPhonenumber.valid_plus_e164_number?()
    refute truncate(plus_e164()) |> AntlPhonenumber.valid_plus_e164_number?()
    refute local_number() |> AntlPhonenumber.valid_plus_e164_number?()
    refute AntlPhonenumber.valid_plus_e164_number?(not_number())
  end

  test "valid?/1" do
    assert plus_e164() |> AntlPhonenumber.valid?()
    refute truncate(plus_e164()) |> AntlPhonenumber.valid?()

    assert_raise ArgumentError,
                 "Missing reference country_code. Use valid?/2 to precise the country_code or provide a plus_e164.",
                 fn -> local_number() |> AntlPhonenumber.valid?() end

    assert_raise ArgumentError,
                 "Missing reference country_code. Use valid?/2 to precise the country_code or provide a plus_e164.",
                 fn -> not_number() |> AntlPhonenumber.valid?() end
  end

  test "valid?/2" do
    plus_e164 = plus_e164()

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert AntlPhonenumber.valid?(plus_e164, country_code)
    refute AntlPhonenumber.valid?(truncate(plus_e164), country_code)
    refute AntlPhonenumber.valid?(not_number(), country_code)
    assert AntlPhonenumber.valid?(local_number(country_code), country_code)
  end

  test "possible?/1" do
    assert plus_e164() |> AntlPhonenumber.possible?()
    refute truncate(plus_e164(), 4) |> AntlPhonenumber.possible?()

    assert_raise ArgumentError,
                 "Missing reference country_code. Use possible?/2 to precise the country_code or provide a plus_e164.",
                 fn -> local_number() |> AntlPhonenumber.possible?() end

    assert_raise ArgumentError,
                 "Missing reference country_code. Use possible?/2 to precise the country_code or provide a plus_e164.",
                 fn ->
                   not_number() |> AntlPhonenumber.possible?()
                 end
  end

  test "possible?/2" do
    plus_e164 = plus_e164()

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert AntlPhonenumber.possible?(plus_e164, country_code)
    refute AntlPhonenumber.possible?(truncate(plus_e164, 4), country_code)
    assert AntlPhonenumber.possible?(local_number(country_code), country_code)
    refute AntlPhonenumber.possible?(not_number(), country_code)
  end

  test "to_plus_e164/1" do
    plus_e164 = plus_e164()

    assert AntlPhonenumber.to_plus_e164(plus_e164) == {:ok, plus_e164}

    assert_raise ArgumentError,
                 "Missing reference country_code. Use to_plus_e164/2 to precise the country_code or provide a plus_e164.",
                 fn -> assert AntlPhonenumber.to_plus_e164(local_number()) end
  end

  test "to_plus_e164/2" do
    plus_e164 = plus_e164()

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert {:ok, ^plus_e164} = AntlPhonenumber.to_plus_e164(plus_e164, country_code)

    assert {:ok, ^plus_e164} =
             AntlPhonenumber.to_plus_e164(local_number(country_code), country_code)

    assert {:error, "parsing error"} = AntlPhonenumber.to_plus_e164(not_number(), country_code)

    assert {:error, "parsing error"} =
             AntlPhonenumber.to_plus_e164(local_number(), "wrong_country_code")
  end

  test "to_plus_e164!/1" do
    plus_e164 = plus_e164()

    assert AntlPhonenumber.to_plus_e164!(plus_e164) == plus_e164

    assert_raise ArgumentError,
                 "Missing reference country_code. Use to_plus_e164!/2 to precise the country_code or provide a plus_e164.",
                 fn -> assert AntlPhonenumber.to_plus_e164!(local_number()) end
  end

  test "to_plus_e164!/2" do
    plus_e164 = plus_e164()

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert AntlPhonenumber.to_plus_e164!(plus_e164, country_code) == plus_e164
    assert AntlPhonenumber.to_plus_e164!(local_number(country_code), country_code) == plus_e164

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.to_plus_e164!(local_number(), "country_code")
    end

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.to_plus_e164!(not_number(), country_code)
    end
  end

  test "to_e164/1" do
    plus_e164 = plus_e164()
    e164 = String.trim_leading(plus_e164, "+")

    assert AntlPhonenumber.to_e164(plus_e164) == {:ok, e164}

    assert_raise ArgumentError,
                 "Missing reference country_code. Use to_e164/2 to precise the country_code or provide a plus_e164.",
                 fn -> assert AntlPhonenumber.to_e164(local_number()) end
  end

  test "to_e164/2" do
    plus_e164 = plus_e164()
    e164 = String.trim_leading(plus_e164, "+")

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert AntlPhonenumber.to_e164(plus_e164, country_code) == {:ok, e164}
    assert AntlPhonenumber.to_e164(local_number(country_code), country_code) == {:ok, e164}

    assert AntlPhonenumber.to_e164(local_number(), "wrong_country_code") ==
             {:error, "parsing error"}

    assert AntlPhonenumber.to_e164(not_number(), country_code) == {:error, "parsing error"}
  end

  test "to_e164!/1" do
    plus_e164 = plus_e164()
    e164 = String.trim_leading(plus_e164, "+")

    assert AntlPhonenumber.to_e164!(plus_e164) == e164

    assert_raise ArgumentError,
                 "Missing reference country_code. Use to_e164!/2 to precise the country_code or provide a plus_e164.",
                 fn -> assert AntlPhonenumber.to_e164!(local_number()) end
  end

  test "to_e164!/2" do
    plus_e164 = plus_e164()
    e164 = String.trim_leading(plus_e164, "+")

    country_code =
      AntlPhonenumber.get_country_prefix!(plus_e164) |> AntlPhonenumber.to_country_code!()

    assert AntlPhonenumber.to_e164!(plus_e164, country_code) == e164
    assert AntlPhonenumber.to_e164!(local_number(country_code), country_code) == e164

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.to_e164!(local_number(), "wrong_country_code")
    end

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.to_e164!(not_number(), country_code)
    end
  end

  test "localize/1" do
    plus_e164 = plus_e164("IL")
    country_prefix = AntlPhonenumber.get_country_prefix!(plus_e164)

    assert AntlPhonenumber.localize(plus_e164) ==
             String.replace_leading(plus_e164, "+#{country_prefix}", "0")

    assert_raise ArgumentError,
                 "Missing reference country_code. Use localize/2 to precise the country_code or provide a plus_e164.",
                 fn -> AntlPhonenumber.localize(local_number()) end

    assert_raise ArgumentError,
                 "Missing reference country_code. Use localize/2 to precise the country_code or provide a plus_e164.",
                 fn -> AntlPhonenumber.localize(not_number()) end
  end

  test "localize/2" do
    plus_e164 = plus_e164()
    country_prefix = AntlPhonenumber.get_country_prefix!(plus_e164)
    country_code = AntlPhonenumber.to_country_code!(country_prefix)
    local_number = String.replace_leading(plus_e164, "+#{country_prefix}", "0")

    assert AntlPhonenumber.localize(plus_e164, country_code) == local_number
    assert AntlPhonenumber.localize(local_number, country_code) == local_number

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.localize(local_number(), "wrong country_code")
    end

    assert_raise RuntimeError, "parsing error", fn ->
      AntlPhonenumber.localize(not_number(), country_code)
    end
  end

  test "get_type/1" do
    assert plus_e164("IL", :mobile) |> AntlPhonenumber.get_type() == {:ok, :mobile}

    assert_raise RuntimeError,
                 "Missing reference country_code. Use get_type/2 to precise the country_code or provide a plus_e164",
                 fn -> AntlPhonenumber.get_type(local_number()) end

    assert_raise RuntimeError,
                 "Missing reference country_code. Use get_type/2 to precise the country_code or provide a plus_e164",
                 fn -> AntlPhonenumber.get_type(not_number()) end
  end

  test "get_type/2" do
    assert local_number("IL", :mobile) |> AntlPhonenumber.get_type("IL") ==
             {:ok, :mobile}

    assert plus_e164("IL", :mobile) |> AntlPhonenumber.get_type("IL") == {:ok, :mobile}

    assert AntlPhonenumber.get_type(not_number(), "IL") == {:error, "parsing error"}
  end

  test "get_country_prefix!/1" do
    assert AntlPhonenumber.get_country_prefix!(plus_e164("IL")) == "972"

    local_number = local_number()

    assert_raise ArgumentError,
                 "Expected a plus_e164 number. Got #{local_number}",
                 fn -> local_number |> AntlPhonenumber.get_country_prefix!() end

    not_number = not_number()

    assert_raise ArgumentError,
                 "Expected a plus_e164 number. Got #{not_number}",
                 fn -> not_number |> AntlPhonenumber.get_country_prefix!() end
  end

  test "get_country_code!/1" do
    assert AntlPhonenumber.get_country_code!(plus_e164("IL")) == "IL"

    local_number = local_number()

    assert_raise ArgumentError,
                 "Expected a plus_e164 number. Got #{local_number}",
                 fn -> local_number |> AntlPhonenumber.get_country_code!() end

    not_number = not_number()

    assert_raise ArgumentError,
                 "Expected a plus_e164 number. Got #{not_number}",
                 fn -> not_number |> AntlPhonenumber.get_country_code!() end
  end

  test "to_country_code!/1" do
    assert AntlPhonenumber.to_country_code!("972") == "IL"
    assert AntlPhonenumber.to_country_code!("33") == "FR"
    assert AntlPhonenumber.to_country_code!("1") == "US"
    assert AntlPhonenumber.to_country_code!("00000")
    assert_raise ArgumentError, fn -> AntlPhonenumber.to_country_code!("eeee") end
  end
end
