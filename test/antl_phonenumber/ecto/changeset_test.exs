defmodule AntlPhonenumber.Ecto.ChangesetTest do
  use AntlPhonenumber.Case
  alias AntlPhonenumber.Ecto.PlusE164

  defmodule Schema do
    use Ecto.Schema

    embedded_schema do
      field(:number, PlusE164)
    end
  end

  describe "validate_iso_country_code/3" do
    test "when the iso_country_code is not the expected one" do
      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164("FR")}, [:number])
        |> AntlPhonenumber.Ecto.Changeset.validate_iso_country_code(:number, "BE")

      refute changeset.valid?
      assert errors_on(changeset).number == ["must be a BE number"]
    end

    test "when the iso_country_code is the expected one" do
      iso_country_code = iso_country_code()

      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164(iso_country_code)}, [:number])
        |> AntlPhonenumber.Ecto.Changeset.validate_iso_country_code(:number, iso_country_code)

      assert changeset.valid?
    end
  end

  describe "validate_type/3" do
    test "when the type is not the expected one" do
      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164(iso_country_code(), :fixed_line)}, [
          :number
        ])
        |> AntlPhonenumber.Ecto.Changeset.validate_type(:number, :mobile)

      refute changeset.valid?
      assert errors_on(changeset).number == ["must be a mobile number"]
    end

    test "when the type is the expected one" do
      type = :mobile

      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164(iso_country_code(), type)}, [:number])
        |> AntlPhonenumber.Ecto.Changeset.validate_type(:number, type)

      assert changeset.valid?
    end

    test "when the type is one of the expected" do
      type = :mobile

      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164(iso_country_code(), type)}, [:number])
        |> AntlPhonenumber.Ecto.Changeset.validate_type(:number, [type, :fixed_line])

      assert changeset.valid?
    end

    test "when the type is not one of the expected" do
      type = :mobile

      changeset =
        %Schema{}
        |> Ecto.Changeset.cast(%{number: plus_e164(iso_country_code(), type)}, [:number])
        |> AntlPhonenumber.Ecto.Changeset.validate_type(:number, [:fixed_line, :voip])

      refute changeset.valid?
      assert errors_on(changeset).number == ["must be one of [:fixed_line, :voip]"]
    end
  end

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
