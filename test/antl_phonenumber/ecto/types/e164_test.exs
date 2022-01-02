defmodule AntlPhonenumber.Ecto.E164Test do
  use AntlPhonenumber.Case
  alias AntlPhonenumber.Ecto.E164

  describe "cast/2 - when the type does not precise the iso_country_code" do
    test "with valid plus_e164, format it to e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()

      assert {:ok, ^e164} = E164.cast(plus_e164, %{})
    end

    test "with not valid plus_e164 number, returns an error" do
      assert E164.cast(plus_e164() <> "00", %{}) == :error
    end

    test "with valid e164, format it to e164" do
      <<?+, e164::binary>> = plus_e164()

      assert {:ok, ^e164} = E164.cast(e164, %{})
    end

    test "with local_number, returns an error" do
      assert E164.cast(local_number() <> "00", %{}) == :error
    end

    test "with not number, returns an error" do
      assert E164.cast(not_number(), %{}) == :error
    end

    test "with nil, returns nil" do
      assert E164.cast(nil, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert E164.cast(not_number(), %{}) == :error
    end
  end

  describe "cast/2 - when the type precises the iso_country_code" do
    test "with valid plus_e164 number, corresponding to the given country code, format it to e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      assert {:ok, ^e164} = E164.cast(plus_e164, %{iso_country_code: iso_country_code})
    end

    test "with valid plus_e164 number, corresponding to a country code different from the given country code" do
      plus_e164 = plus_e164("FR")
      assert E164.cast(plus_e164, %{iso_country_code: "BE"}) == :error
    end

    test "with not valid plus_e164 number, returns an error" do
      assert E164.cast(plus_e164() <> "00", %{iso_country_code: iso_country_code()}) == :error
    end

    test "with local_number, valid for the iso_country_code, format it to e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      local_number = AntlPhonenumber.to_local(plus_e164)

      assert {:ok, ^e164} = E164.cast(local_number, %{iso_country_code: iso_country_code})
    end

    test "with local_number, invalid for the iso_country_code, returns an error" do
      plus_e164 = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      local_number = AntlPhonenumber.to_local(plus_e164)

      assert E164.cast(local_number <> "00", %{iso_country_code: iso_country_code}) == :error
    end

    test "with nil, returns nil" do
      assert E164.cast(nil, %{iso_country_code: iso_country_code()}) == {:ok, nil}
    end

    test "catch all " do
      assert E164.cast(not_number(), %{iso_country_code: iso_country_code()}) == :error
    end
  end

  describe "load/3 - when the type does not precise the iso_country_code" do
    test "with valid number in e164 format" do
      <<?+, e164::binary>> = plus_e164()
      assert {:ok, ^e164} = E164.load(e164, fn -> :noop end, %{})
    end

    test "with not valid number in e164 format, returns an error" do
      <<?+, e164::binary>> = plus_e164()
      assert E164.load(e164 <> "00", fn -> :noop end, %{}) == :error
    end

    test "with plus_e164, returns an error" do
      assert E164.load(plus_e164(), fn -> :noop end, %{}) == :error
    end

    test "with local_number, returns an error" do
      assert E164.load(local_number() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with not number, returns an error" do
      assert E164.load(not_number(), fn -> :noop end, %{}) == :error
    end

    test "with nil, returns nil" do
      assert E164.load(nil, fn -> :noop end, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert E164.load(not_number(), fn -> :noop end, %{}) == :error
    end
  end

  describe "load/3 - when the type precises the iso_country_code" do
    test "with valid number, corresponding to the given country code, in e164 format, returns it" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)

      assert {:ok, ^e164} =
               E164.load(e164, fn -> :noop end, %{iso_country_code: iso_country_code})
    end

    test "with valid number, corresponding to a country code different from the given country code, in e164 format" do
      <<?+, e164::binary>> = plus_e164("FR")
      assert E164.load(e164, fn -> :noop end, %{iso_country_code: "BE"}) == :error
    end

    test "with not valid e164 number, returns an error" do
      <<?+, e164::binary>> = plus_e164()

      assert E164.load(e164 <> "00", fn -> :noop end, %{iso_country_code: iso_country_code()}) ==
               :error
    end

    test "with local_number, returns an error" do
      plus_e164 = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      local_number = AntlPhonenumber.to_local(plus_e164)

      assert E164.load(local_number, fn -> :noop end, %{iso_country_code: iso_country_code}) ==
               :error
    end

    test "with nil, returns nil" do
      assert E164.load(nil, fn -> :noop end, %{iso_country_code: iso_country_code()}) ==
               {:ok, nil}
    end

    test "catch all " do
      assert E164.load(not_number(), fn -> :noop end, %{iso_country_code: iso_country_code()}) ==
               :error
    end
  end

  describe "dump/3 - when the type does not precise the iso_country_code" do
    test "with valid plus_e164, format it to e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      assert {:ok, ^e164} = E164.dump(plus_e164, fn -> :noop end, %{})
    end

    test "with not valid plus_e164 number, returns an error" do
      assert E164.dump(plus_e164() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with valid e164, format it to e164" do
      <<?+, e164::binary>> = plus_e164()
      assert {:ok, ^e164} = E164.dump(e164, fn -> :noop end, %{})
    end

    test "with local_number, returns an error" do
      assert E164.dump(local_number() <> "00", fn -> :noop end, %{}) == :error
    end

    test "with not number, returns an error" do
      assert E164.dump(not_number(), fn -> :noop end, %{}) == :error
    end

    test "with nil, returns nil" do
      assert E164.dump(nil, fn -> :noop end, %{}) == {:ok, nil}
    end

    test "catch all " do
      assert E164.dump(not_number(), fn -> :noop end, %{}) == :error
    end
  end

  describe "dump/3 - when the type precises the iso_country_code" do
    test "with valid plus_e164 number, corresponding to the given country code, format it to e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)

      assert {:ok, ^e164} =
               E164.dump(plus_e164, fn -> :noop end, %{iso_country_code: iso_country_code})
    end

    test "with valid plus_e164 number, corresponding to a country code different from the given country code" do
      plus_e164 = plus_e164("FR")
      assert E164.dump(plus_e164, fn -> :noop end, %{iso_country_code: "BE"}) == :error
    end

    test "with not valid plus_e164 number, returns an error" do
      assert E164.dump(plus_e164() <> "00", fn -> :noop end, %{
               iso_country_code: iso_country_code()
             }) ==
               :error
    end

    test "with local_number, valid for the iso_country_code, format it to plus_e164" do
      plus_e164 = <<?+, e164::binary>> = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      local_number = AntlPhonenumber.to_local(plus_e164)

      assert {:ok, ^e164} =
               E164.dump(local_number, fn -> :noop end, %{iso_country_code: iso_country_code})
    end

    test "with local_number, invalid for the iso_country_code, returns an error" do
      plus_e164 = plus_e164()
      iso_country_code = AntlPhonenumber.get_iso_country_code!(plus_e164)
      local_number = AntlPhonenumber.to_local(plus_e164)

      assert E164.dump(local_number <> "00", fn -> :noop end, %{
               iso_country_code: iso_country_code
             }) ==
               :error
    end

    test "with nil, returns nil" do
      assert E164.dump(nil, fn -> :noop end, %{iso_country_code: iso_country_code()}) ==
               {:ok, nil}
    end

    test "catch all " do
      assert E164.dump(not_number(), fn -> :noop end, %{iso_country_code: iso_country_code()}) ==
               :error
    end
  end
end
