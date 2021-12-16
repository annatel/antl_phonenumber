defmodule AntlPhonenumber do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  alias AntlPhonenumber.Nif

  @default_ref_country_code "IL"
  # @supported_formats ~w(e164 international national rfc3966)
  @supported_formats ~w(e164 national)
  @supported_types ~w(premium_rate toll_free mobile fixed_line shared_cost voip personal_number pager uan voicemail)a

  @doc """
  Returns true if the number is well-formatted in plus_e164 format.
  Otherwise, returns false.
  """
  @spec plus_e164?(binary) :: boolean
  def plus_e164?(number) do
    case plus_e164(number, @default_ref_country_code) do
      {:ok, plus_e164} -> plus_e164 == number
      {:error, _} -> false
    end
  end

  @doc """
  Returns true if the number is well-formatted in plus_e164 format and is valid.
  Otherwise, returns false.
  """
  @spec valid_plus_e164_number?(binary) :: boolean
  def valid_plus_e164_number?(number) do
    plus_e164?(number) and valid?(number)
  end

  @doc """
  Returns true if the number is valid.
  Otherwise, returns false.

  Note that if the number is not formatted in plus_e164 format, a reference country_code is required to
  determine the validity of the number.
  """
  @spec valid?(binary, binary | nil) :: boolean
  def valid?(number) when is_binary(number) do
    unless plus_e164?(number) do
      raise ArgumentError,
            "Missing reference country_code. Use valid?/2 to precise the country_code or provide a plus_e164."
    end

    valid?(number, @default_ref_country_code)
  end

  def valid?(number, ref_country_code) when is_binary(number) and is_binary(ref_country_code) do
    Nif.is_valid(to_charlist(number), to_charlist(ref_country_code))
  end

  @doc """
  Returns true if the number is possible.
  Otherwise, returns false.

  Note that if the number is not formatted in plus_e164 format, a reference country_code is required to
  determine the possibility of the number.
  """
  @spec possible?(binary, binary | nil) :: boolean
  def possible?(number) when is_binary(number) do
    unless plus_e164?(number) do
      raise ArgumentError,
            "Missing reference country_code. Use possible?/2 to precise the country_code or provide a plus_e164."
    end

    possible?(number, @default_ref_country_code)
  end

  def possible?(number, ref_country_code)
      when is_binary(number) and is_binary(ref_country_code) do
    Nif.is_possible(to_charlist(number), to_charlist(ref_country_code))
  end

  @doc """
  Format a number to plus_e164 format.
  Note that a reference country_code is required.
  """
  @spec plus_e164(binary, binary) :: {:ok, binary} | {:error, binary}
  def plus_e164(number, ref_country_code) do
    format(number, "e164", ref_country_code)
  end

  @doc """
  Same as `c:plus_e164/2`, but raises on parsing/formatting error.
  """
  @spec plus_e164!(binary, binary) :: binary
  def plus_e164!(number, ref_country_code) do
    format!(number, "e164", ref_country_code)
  end

  @doc """
  Format a number to e164 (without plus) format.
  Note that a reference country_code is required.
  Raises on parsing/formatting error.
  """
  @spec e164!(binary, binary) :: binary
  def e164!(number, ref_country_code) do
    <<?+, e164::binary>> = number |> format!("e164", ref_country_code)

    e164
  end

  @doc """
  Format a number to local format.
  Note that if the number is not formatted in plus_e164 format, a reference country_code is required.
  """
  @spec localize(binary) :: binary
  def localize(plus_e164) do
    unless plus_e164?(plus_e164) do
      raise ArgumentError,
            "Missing reference country_code. Use localize/2 to precise the country_code or provide a plus_e164."
    end

    localize(plus_e164, @default_ref_country_code)
  end

  @spec localize(binary, binary) :: binary
  def localize(plus_e164, ref_country_code) do
    plus_e164
    |> format!("national", ref_country_code)
    |> String.replace("-", "")
    |> String.replace(" ", "")
  end

  @doc """
  Returns the type of the number. It can be one of the list below:
  (#{@supported_types |> Enum.join(",")}).
  Note that if the number is not formatted in plus_e164 format, a reference country_code is required.
  """
  @spec get_type(binary, binary | nil) :: {:ok, atom} | {:error, binary}
  def get_type(number) when is_binary(number) do
    unless plus_e164?(number) do
      raise "Missing reference country_code. Use get_type/2 to precise the country_code or provide a plus_e164"
    end

    get_type(number, @default_ref_country_code)
  end

  def get_type(number, ref_country_code) when is_binary(number) and is_binary(ref_country_code) do
    Nif.get_type(to_charlist(number), to_charlist(ref_country_code))
    |> then(fn {status, message} -> {status, to_string(message)} end)
    |> case do
      {:ok, type} -> {:ok, type |> String.to_atom()}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns the country code of the number.
  Note that the number must be formatted in plus_e164 format.
  """
  @spec get_country_code!(binary) :: binary
  def get_country_code!(plus_e164) when is_binary(plus_e164) do
    get_country_prefix!(plus_e164) |> to_country_code!()
  end

  @doc """
  Returns the country prefix of the number.
  Note that the number must be formatted in plus_e164 format.
  """
  @spec get_country_prefix!(binary) :: binary
  def get_country_prefix!(plus_e164) when is_binary(plus_e164) do
    unless plus_e164?(plus_e164) do
      raise ArgumentError, "Expected a plus_e164 number. Got #{plus_e164}"
    end

    {status, message} =
      Nif.get_country_prefix(to_charlist(plus_e164), to_charlist(@default_ref_country_code))

    case {status, to_string(message)} do
      {:ok, country_prefix} -> country_prefix
      {:error, error} -> raise error
    end
  end

  @doc """
  Returns the country code corresponding to the country prefix.
  """
  @spec to_country_code!(binary) :: binary
  def to_country_code!(country_code) when is_binary(country_code) do
    country_code |> String.to_integer() |> Nif.to_country_code() |> to_string()
  end

  @doc """
  Get from Google a plus e164 number.
  """
  @spec get_plus_e164_example(binary, binary) :: binary
  def get_plus_e164_example(country_code, type) when type in @supported_types do
    Nif.get_plus_e164_example(to_charlist(country_code), type |> to_string |> to_charlist())
    |> to_string
  end

  def supported_types(), do: @supported_types

  # Helper functions

  @doc false
  def move(number, steps) when is_integer(steps) do
    AntlPhonenumber.plus_e164?(number) || raise "Missing reference country_code."

    "+" <> to_string(to_integer(number) + steps)
  end

  def move(number, country_code, steps) when is_integer(steps) do
    number |> plus_e164!(country_code) |> move(steps)
  end

  @doc false
  def next(number), do: move(number, 1)

  @doc false
  def previous(number), do: move(number, -1)

  @doc false
  def to_integer(plus_e164) do
    AntlPhonenumber.plus_e164?(plus_e164) || raise ""

    <<?+, e164::binary>> = plus_e164
    String.to_integer(e164)
  end

  defp format!(number, format, ref_country_code)
       when is_binary(number) and format in @supported_formats and is_binary(ref_country_code) do
    case format(number, format, ref_country_code) do
      {:ok, formatted_number} -> formatted_number
      {:error, error} -> raise error
    end
  end

  defp format(number, format, ref_country_code)
       when is_binary(number) and format in @supported_formats and is_binary(ref_country_code) do
    {status, message} =
      Nif.format(
        to_charlist(number),
        format |> to_string |> to_charlist(),
        to_charlist(ref_country_code)
      )

    {status, to_string(message)}
  end
end
