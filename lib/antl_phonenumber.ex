defmodule AntlPhonenumber do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  alias AntlPhonenumber.Nif

  @default_ref_iso_country_code "IL"
  # @supported_formats ~w(e164 international national rfc3966)
  @google_supported_formats ~w(e164 national)
  @supported_types ~w(premium_rate toll_free mobile fixed_line shared_cost voip personal_number pager uan voicemail)a
  @missing_iso_country_code_error_message "Missing reference iso_country_code. Please specify the iso_country_code or provide a e164/plus_e164."

  @doc """
  Returns true if the number is well-formatted in plus_e164 format.
  Otherwise, returns false.
  """
  @spec plus_e164?(binary) :: boolean
  def plus_e164?(number) do
    case to_plus_e164(number, @default_ref_iso_country_code) do
      {:ok, ^number} -> true
      _ -> false
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

  Note that if the number is not formatted in plus_e164 nor in e164 format, a reference iso_country_code is required to
  determine the validity of the number.
  """
  @spec valid?(binary, binary | nil) :: boolean
  def valid?(<<?+, _::binary>> = number), do: valid?(number, @default_ref_iso_country_code)

  def valid?(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    valid?("+" <> number, @default_ref_iso_country_code)
  end

  def valid?(number, ref_iso_country_code)
      when is_binary(number) and is_binary(ref_iso_country_code) do
    Nif.is_valid(to_charlist(number), to_charlist(ref_iso_country_code))
  end

  @doc """
  Returns true if the number is possible.
  Otherwise, returns false.

  Note that if the number is not formatted in plus_e164 nor in e164 format, a reference iso_country_code is required to
  determine the possibility of the number.
  """
  @spec possible?(binary, binary | nil) :: boolean
  def possible?(<<?+, _::binary>> = number), do: possible?(number, @default_ref_iso_country_code)

  def possible?(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    possible?("+" <> number, @default_ref_iso_country_code)
  end

  def possible?(number, ref_iso_country_code)
      when is_binary(number) and is_binary(ref_iso_country_code) do
    Nif.is_possible(to_charlist(number), to_charlist(ref_iso_country_code))
  end

  @doc """
  Format a number to plus_e164 format.
  Note that if the number is not formatted in plus_e164 nor in e164 format, a reference iso_country_code is required.
  """
  @spec to_plus_e164(binary, binary | nil) :: {:ok, binary} | {:error, binary}
  def to_plus_e164(<<?+, _::binary>> = number),
    do: to_plus_e164(number, @default_ref_iso_country_code)

  def to_plus_e164(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    to_plus_e164("+" <> number)
  end

  def to_plus_e164(number, ref_iso_country_code) do
    google_format(number, "e164", ref_iso_country_code)
  end

  @doc """
  Same as `c:to_plus_e164/1` and `c:to_plus_e164/2`, but raises on parsing/formatting error.
  """
  @spec to_plus_e164!(binary, binary | nil) :: binary
  def to_plus_e164!(number) do
    case to_plus_e164(number) do
      {:ok, plus_e164} -> plus_e164
      {:error, error} -> raise error
    end
  end

  def to_plus_e164!(number, ref_iso_country_code) do
    case to_plus_e164(number, ref_iso_country_code) do
      {:ok, plus_e164} -> plus_e164
      {:error, error} -> raise error
    end
  end

  @doc """
  Format a number to e164 (without plus) format.
  Note that if the number is not formatted in plus_e164 format nor in e164 , a reference iso_country_code is required.
  """
  @spec to_e164(binary, binary | nil) :: {:ok, binary} | {:error, binary}
  def to_e164(<<?+, _::binary>> = number) do
    to_e164(number, @default_ref_iso_country_code)
  end

  def to_e164(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    to_e164("+" <> number)
  end

  def to_e164(number, ref_iso_country_code) do
    case to_plus_e164(number, ref_iso_country_code) do
      {:ok, <<?+, e164::binary>>} -> {:ok, e164}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Same as `c:to_e164/1` and `c:to_e164/2`, but raises on parsing/formatting error.
  """
  @spec to_e164!(binary, binary | nil) :: binary
  def to_e164!(number) do
    case to_e164(number) do
      {:ok, e164} -> e164
      {:error, error} -> raise error
    end
  end

  def to_e164!(number, ref_iso_country_code) do
    case to_e164(number, ref_iso_country_code) do
      {:ok, e164} -> e164
      {:error, error} -> raise error
    end
  end

  @doc """
  Format a number to local format.
  Note that if the number is not formatted in plus_e164 nor in e164 format, a reference iso_country_code is required.
  """
  @spec to_local(binary) :: binary
  def to_local(<<?+, _::binary>> = number) do
    to_local(number, @default_ref_iso_country_code)
  end

  def to_local(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    to_local("+" <> number)
  end

  @spec to_local(binary, binary) :: binary
  def to_local(plus_e164, ref_iso_country_code) do
    plus_e164
    |> google_format!("national", ref_iso_country_code)
    |> String.replace("-", "")
    |> String.replace(" ", "")
  end

  @doc """
  Returns the type of the number. It can be one of the list below:
  (#{@supported_types |> Enum.join(",")}).
  Note that if the number is not formatted in plus_e164 nor in e164 format, a reference iso_country_code is required.
  """
  @spec get_type(binary, binary | nil) :: {:ok, atom} | {:error, binary}
  def get_type(<<?+, _::binary>> = number), do: get_type(number, @default_ref_iso_country_code)

  def get_type(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, @missing_iso_country_code_error_message)

    get_type("+" <> number)
  end

  def get_type(number, ref_iso_country_code)
      when is_binary(number) and is_binary(ref_iso_country_code) do
    Nif.get_type(to_charlist(number), to_charlist(ref_iso_country_code))
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
  @spec get_iso_country_code!(binary) :: binary

  def get_iso_country_code!(<<?+, _::binary>> = number),
    do: get_country_code!(number) |> to_iso_country_code!()

  def get_iso_country_code!(number) when is_binary(number) do
    unless plus_e164?("+" <> number),
      do: raise(ArgumentError, "Expected a plus_e164 or a e164 number. Got #{number}")

    get_iso_country_code!("+" <> number)
  end

  @doc """
  Returns the country prefix of the number.
  Note that the number must be formatted in plus_e164 format.
  """
  @spec get_country_code!(binary) :: binary
  def get_country_code!(<<?+, _::binary>> = number) do
    {status, message} =
      Nif.get_country_code(to_charlist(number), to_charlist(@default_ref_iso_country_code))

    case {status, to_string(message)} do
      {:ok, country_code} -> country_code
      {:error, error} -> raise error
    end
  end

  def get_country_code!(number) when is_binary(number) do
    unless plus_e164?("+" <> number) do
      raise ArgumentError, "Expected a plus_e164 or a e164 number. Got #{number}"
    end

    get_country_code!("+" <> number)
  end

  @doc """
  Returns the country code corresponding to the country prefix.
  """
  @spec to_iso_country_code!(binary) :: binary
  def to_iso_country_code!(iso_country_code) when is_binary(iso_country_code) do
    iso_country_code |> String.to_integer() |> Nif.to_iso_country_code() |> to_string()
  end

  @doc """
  Get from Google a plus e164 number.
  """
  @spec get_plus_e164_example(binary, atom) :: binary
  def get_plus_e164_example(iso_country_code, type) when type in @supported_types do
    Nif.get_plus_e164_example(to_charlist(iso_country_code), type |> to_string |> to_charlist())
    |> to_string
  end

  def supported_types(), do: @supported_types

  # Helper functions

  @doc false
  def move(number, steps) when is_integer(steps) do
    AntlPhonenumber.plus_e164?(number) || raise "Missing reference iso_country_code."

    "+" <> to_string(to_integer(number) + steps)
  end

  def move(number, iso_country_code, steps) when is_integer(steps) do
    number |> to_plus_e164!(iso_country_code) |> move(steps)
  end

  @doc false
  def next(number), do: move(number, 1)

  @doc false
  def previous(number), do: move(number, -1)

  @doc false
  def to_integer(plus_e164) do
    AntlPhonenumber.plus_e164?(plus_e164) || raise ""

    plus_e164 |> to_e164!() |> String.to_integer()
  end

  defp google_format(number, format, ref_iso_country_code)
       when is_binary(number) and format in @google_supported_formats and
              is_binary(ref_iso_country_code) do
    {status, message} =
      Nif.format(
        to_charlist(number),
        format |> to_string |> to_charlist(),
        to_charlist(ref_iso_country_code)
      )

    {status, to_string(message)}
  end

  defp google_format!(number, format, ref_iso_country_code)
       when is_binary(number) and format in @google_supported_formats and
              is_binary(ref_iso_country_code) do
    case google_format(number, format, ref_iso_country_code) do
      {:ok, formatted_number} -> formatted_number
      {:error, error} -> raise error
    end
  end
end
