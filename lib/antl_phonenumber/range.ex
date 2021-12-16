defmodule AntlPhonenumber.Range do
  @moduledoc """
  Defines a range of phone numbers.
  """

  defstruct first: nil, last: nil, country_code: nil

  @type t :: %__MODULE__{
          first: String.t(),
          last: String.t(),
          country_code: String.t()
        }

  @doc """
  Creates a new range.

  ## Examples
      iex> AntlPhonenumber.Range.new "0548451840", "0548451845", "IL"
      %AntlPhonenumber.Range{
        first: "972548451840",
        last: "972548451845",
        country_code: "IL"
      }
  """
  @spec new(String.t(), String.t(), String.t()) :: t
  def new(first, last, country_code) when is_binary(first) and is_binary(last) do
    first = AntlPhonenumber.plus_e164!(first, country_code)
    last = AntlPhonenumber.plus_e164!(last, country_code)

    if AntlPhonenumber.get_country_code!(first) !=
         AntlPhonenumber.get_country_code!(last) do
      raise ArgumentError,
            "ranges (first..last) expect both sides to have the same contry_code, " <>
              "got: #{inspect(first)}..#{inspect(last)}"
    end

    %__MODULE__{first: first, last: last, country_code: country_code}
  end

  defimpl Enumerable, for: AntlPhonenumber.Range do
    import AntlPhonenumber, only: [to_integer: 1, next: 1, previous: 1, move: 2]

    def reduce(%AntlPhonenumber.Range{first: first, last: last} = range, acc, fun),
      do: reduce(first, last, acc, fun, _asc? = asc?(range))

    defp reduce(_first, _last, {:halt, acc}, _fun, _asc?), do: {:halted, acc}

    defp reduce(first, last, {:suspend, acc}, fun, asc?),
      do: {:suspended, acc, &reduce(first, last, &1, fun, asc?)}

    defp reduce(first, last, {:cont, acc}, fun, _asc? = true) when first <= last,
      do: reduce(next(first), last, fun.(first, acc), fun, _asc? = true)

    defp reduce(first, last, {:cont, acc}, fun, _asc? = false) when first >= last,
      do: reduce(previous(first), last, fun.(first, acc), fun, _asc? = false)

    defp reduce(_, _, {:cont, acc}, _fun, _asc?), do: {:done, acc}

    def member?(%AntlPhonenumber.Range{} = range, number) do
      case AntlPhonenumber.plus_e164(number, range.country_code) do
        {:ok, plus_e164} -> {:ok, member_as_plus_e164?(range, plus_e164)}
        _ -> {:ok, false}
      end
    end

    defp member_as_plus_e164?(%AntlPhonenumber.Range{} = range, plus_e164) do
      if asc?(range),
        do: range.first <= plus_e164 and plus_e164 <= range.last,
        else: range.last <= plus_e164 and plus_e164 <= range.first
    end

    def count(%AntlPhonenumber.Range{} = range),
      do: {:ok, abs(to_integer(range.last) - to_integer(range.first)) + 1}

    def slice(%AntlPhonenumber.Range{} = range) do
      if asc?(range),
        do: {:ok, Enum.count(range), &slice_asc(move(range.first, &1), &2)},
        else: {:ok, Enum.count(range), &slice_desc(move(range.first, -&1), &2)}
    end

    defp slice_asc(current, 1), do: [current]

    defp slice_asc(current, remaining) do
      [current | slice_asc(next(current), remaining - 1)]
    end

    defp slice_desc(current, 1), do: [current]

    defp slice_desc(current, remaining) do
      [current | slice_desc(previous(current), remaining - 1)]
    end

    defp asc?(%AntlPhonenumber.Range{} = range), do: range.first <= range.last
  end

  defimpl Inspect do
    def inspect(%AntlPhonenumber.Range{first: first, last: last}, _), do: "#{first}..#{last}"

    # def inspect(range, opts), do: Inspect.Any.inspect(range, opts)
  end
end
