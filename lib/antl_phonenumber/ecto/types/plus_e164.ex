if Code.ensure_loaded?(Ecto.ParameterizedType) do
  defmodule AntlPhonenumber.Ecto.PlusE164 do
    @moduledoc """
    An Ecto type for plus_e164 formatted numbers.

    It can be used like this:

    defmodule Schema do
      use Ecto.Schema

      embedded_schema do
        field(:number, PlusE164)
        field(:number, PlusE164, default_iso_country_code: "FR")
        field(:french_number, PlusE164, iso_country_code: "FR")
      end
    end
    """
    use Ecto.ParameterizedType

    @type t :: binary

    @spec type(any) :: :string
    def type(_), do: :string

    @spec init(keyword) :: map
    def init(opts), do: Enum.into(opts, %{})

    @spec cast(binary | nil, map) :: {:ok, t() | nil} | :error
    def cast(number, %{iso_country_code: iso_country_code}) when is_binary(number) do
      with {:ok, plus_e164} <- AntlPhonenumber.to_plus_e164(number, iso_country_code),
           true <- AntlPhonenumber.valid?(plus_e164),
           ^iso_country_code <- AntlPhonenumber.get_iso_country_code!(plus_e164) do
        {:ok, plus_e164}
      else
        _ -> :error
      end
    end

    def cast(number, %{default_iso_country_code: default_iso_country_code})
        when is_binary(number) do
      with {:ok, plus_e164} <- AntlPhonenumber.to_plus_e164(number, default_iso_country_code),
           true <- AntlPhonenumber.valid?(plus_e164) do
        {:ok, plus_e164}
      else
        _ -> :error
      end
    end

    def cast(number, %{}) when is_binary(number) do
      if AntlPhonenumber.valid_plus_e164_number?(number),
        do: {:ok, number},
        else: :error
    end

    def cast(nil, _), do: {:ok, nil}
    def cast(_, _), do: :error

    @spec load(binary | nil, fun, map) :: {:ok, t() | nil}
    def load(number, _, %{iso_country_code: iso_country_code}) when is_binary(number) do
      with true <- AntlPhonenumber.valid_plus_e164_number?(number),
           ^iso_country_code <- AntlPhonenumber.get_iso_country_code!(number) do
        {:ok, number}
      else
        _ -> :error
      end
    end

    def load(number, _, %{}) when is_binary(number) do
      if AntlPhonenumber.valid_plus_e164_number?(number),
        do: {:ok, number},
        else: :error
    end

    def load(nil, _, _), do: {:ok, nil}
    def load(_, _, _), do: :error

    @spec dump(t() | nil, fun, map) :: {:ok, binary | nil} | :error
    def dump(number, _, %{iso_country_code: iso_country_code}) when is_binary(number) do
      with {:ok, plus_e164} <- AntlPhonenumber.to_plus_e164(number, iso_country_code),
           true <- AntlPhonenumber.valid?(plus_e164),
           ^iso_country_code <- AntlPhonenumber.get_iso_country_code!(plus_e164) do
        {:ok, plus_e164}
      else
        _ -> :error
      end
    end

    def dump(number, _, %{default_iso_country_code: iso_country_code}) when is_binary(number) do
      with {:ok, plus_e164} <- AntlPhonenumber.to_plus_e164(number, iso_country_code),
           true <- AntlPhonenumber.valid?(plus_e164) do
        {:ok, plus_e164}
      else
        _ -> :error
      end
    end

    def dump(number, _, %{}) when is_binary(number) do
      if AntlPhonenumber.valid_plus_e164_number?(number),
        do: {:ok, number},
        else: :error
    end

    def dump(nil, _, _), do: {:ok, nil}
    def dump(_, _, _), do: :error
  end
end
