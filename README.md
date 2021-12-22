# AntlPhonenumber

<!-- MDOC !-->
AntlPhonenumber is a third-party port of the [google libphonenumber library](https://github.com/google/libphonenumber).\
The library is based on google libphonenumber cpp implementation and implements NIF functions.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `antl_phonenumber` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:antl_phonenumber, "~> 0.1.0"}
  ]
end
```

The library supposes that google libphonenumber is installed.
Please refer to the [installation doc of C++ version](https://github.com/google/libphonenumber/blob/master/cpp/README) to build the library.

## Usage

AntlPhonenumber provides a set of predicates and functions to check or manipulate a number.

### Ecto types
It also provides a PlusE164 Ecto type ensuring the number will be dump and load only in plus e164 format.\
A number in any other format won't be cast, as country code is required to format it in plus e164 format.\
However, if `country_code` is specified, the type will ensure the number belongs to the given country code and casting will be performed accordingly to this country code.\
In that case, any number of another country (a.k.a any plus_e164 of another country) will cause casting to fail.\

Example:

```elixir
    import AntlPhonenumber.Ecto.PlusE164

    embedded_schema do
      field(:number, PlusE164)
      field(:french_number, PlusE164, country_code: "FR")
    end
```
PlusE164 fit our needs.\
But any type can be created to express a combination of number characteristics. For instance, one could need a type for local french numbers. It is easy to implement another type based on PlusE164 implementation.

### Ecto changeset
Changeset validations are also a AntlPhonenumber feature.\
For the moment, the validators are:

```elixir
  validate_country_code/3
  validate_type/3
```
### Ranges
Number ranges are also supported and implement the Enumerable protocol so we can apply Enum functions on them.\
The ranges can be ascendant or descendant.\
For example:

```elixir
  range = AntlPhonenumber.Range.new("+33148413200", "+33148413210", "FR")
  range = AntlPhonenumber.Range.new("0148413200", "0148413210", "FR")
  range = AntlPhonenumber.Range.new("0148413210", "0148413200", "FR")
```

### Testing

Google provides number examples. The function get_plus_e164_example/2, receiving a country code and a number type allow to request an example number.\
It is useful for testing.\

```elixir
  AntlPhonenumber.get_plus_e164_example("FR", :mobile)
```

