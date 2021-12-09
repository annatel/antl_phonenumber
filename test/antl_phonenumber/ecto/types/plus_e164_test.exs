defmodule AntlPhonenumber.Ecto.PlusE164Test do
  use AntlPhonenumber.Case
  alias AntlPhonenumber.Ecto.PlusE164

  describe "cast/2 - when the type does not precise the country_code" do
    test "cast valid plus_e164" do
      plus_e164 = plus_e164()
      assert {:ok, ^plus_e164} = PlusE164.cast(plus_e164, %{})
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.cast(plus_e164() <> "00", %{}) == :error
    end

    test "with local_number, returns an error" do
      assert PlusE164.cast(local_number() <> "00", %{}) == :error
    end

    test "with not number, returns an error" do
      assert PlusE164.cast(not_number(), %{}) == :error
    end

    test "with nil, returns nil" do
      assert PlusE164.cast(nil, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.cast(not_number(), %{}) == :error
    end
  end

  describe "cast/2 - when the type precises the country_code" do
    test "with valid plus_e164 number, corresponding to the given country code, returns it" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      assert {:ok, ^plus_e164} = PlusE164.cast(plus_e164, %{country_code: country_code})
    end

    test "with valid plus_e164 number, corresponding to a country code different from the given country code" do
      plus_e164 = plus_e164("FR")
      assert PlusE164.cast(plus_e164, %{country_code: "BE"}) == :error
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.cast(plus_e164() <> "00", %{country_code: country_code()}) == :error
    end

    test "with local_number, valid for the country_code, format it to plus_e164" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      local_number = AntlPhonenumber.localize(plus_e164)

      assert {:ok, ^plus_e164} = PlusE164.cast(local_number, %{country_code: country_code})
    end

    test "with local_number, invalid for the country_code, returns an error" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      local_number = AntlPhonenumber.localize(plus_e164)

      assert PlusE164.cast(local_number <> "00", %{country_code: country_code}) == :error
    end

    test "with nil, returns nil" do
      assert PlusE164.cast(nil, %{country_code: country_code()}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.cast(not_number(), %{country_code: country_code()}) == :error
    end
  end

  describe "load/3 - when the type does not precise the country_code" do
    test "with valid plus_e164 number" do
      plus_e164 = plus_e164()
      assert {:ok, ^plus_e164} = PlusE164.load(plus_e164, fn -> :noop end, %{})
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.load(plus_e164() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with local_number, returns an error" do
      assert PlusE164.load(local_number() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with not number, returns an error" do
      assert PlusE164.load(not_number(), fn -> :noop end, %{}) == :error
    end

    test "with nil, returns nil" do
      assert PlusE164.load(nil, fn -> :noop end, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.load(not_number(), fn -> :noop end, %{}) == :error
    end
  end

  describe "load/3 - when the type precises the country_code" do
    test "with valid plus_e164 number, corresponding to the given country code, returns it" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)

      assert {:ok, ^plus_e164} =
               PlusE164.load(plus_e164, fn -> :noop end, %{country_code: country_code})
    end

    test "with valid plus_e164 number, corresponding to a country code different from the given country code" do
      plus_e164 = plus_e164("FR")
      assert PlusE164.load(plus_e164, fn -> :noop end, %{country_code: "BE"}) == :error
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.load(plus_e164() <> "00", fn -> :noop end, %{country_code: country_code()}) ==
               :error
    end

    test "with local_number, returns an error" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      local_number = AntlPhonenumber.localize(plus_e164)

      assert PlusE164.load(local_number, fn -> :noop end, %{country_code: country_code}) ==
               :error
    end

    test "with nil, returns nil" do
      assert PlusE164.load(nil, fn -> :noop end, %{country_code: country_code()}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.load(not_number(), fn -> :noop end, %{country_code: country_code()}) ==
               :error
    end
  end

  describe "dump/3 - when the type does not precise the country_code" do
    test "dump valid plus_e164" do
      plus_e164 = plus_e164()
      assert {:ok, ^plus_e164} = PlusE164.dump(plus_e164, fn -> :noop end, %{})
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.dump(plus_e164() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with local_number, returns an error" do
      assert PlusE164.dump(local_number() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with not number, returns an error" do
      assert PlusE164.dump(not_number(), fn -> :noop end, %{}) == :error
    end

    test "with nil, returns nil" do
      assert PlusE164.dump(nil, fn -> :noop end, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.dump(not_number(), fn -> :noop end, %{}) == :error
    end
  end

  describe "dump/3 - when the type precises the country_code" do
    test "with valid plus_e164 number, corresponding to the given country code, returns it" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)

      assert {:ok, ^plus_e164} =
               PlusE164.dump(plus_e164, fn -> :noop end, %{country_code: country_code})
    end

    test "with valid plus_e164 number, corresponding to a country code different from the given country code" do
      plus_e164 = plus_e164("FR")
      assert PlusE164.dump(plus_e164, fn -> :noop end, %{country_code: "BE"}) == :error
    end

    test "with not valid plus_e164 number, returns an error" do
      assert PlusE164.dump(plus_e164() <> "00", fn -> :noop end, %{country_code: country_code()}) ==
               :error
    end

    test "with local_number, valid for the country_code, format it to plus_e164" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      local_number = AntlPhonenumber.localize(plus_e164)

      assert {:ok, ^plus_e164} =
               PlusE164.dump(local_number, fn -> :noop end, %{country_code: country_code})
    end

    test "with local_number, invalid for the country_code, returns an error" do
      plus_e164 = plus_e164()
      country_code = AntlPhonenumber.get_country_code!(plus_e164)
      local_number = AntlPhonenumber.localize(plus_e164)

      assert PlusE164.dump(local_number <> "00", fn -> :noop end, %{country_code: country_code}) ==
               :error
    end

    test "with nil, returns nil" do
      assert PlusE164.dump(nil, fn -> :noop end, %{country_code: country_code()}) == {:ok, nil}
    end

    test "catch all " do
      assert PlusE164.dump(not_number(), fn -> :noop end, %{country_code: country_code()}) ==
               :error
    end
  end
end
