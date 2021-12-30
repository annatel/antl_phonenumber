if Code.ensure_loaded?(Ecto.Changeset) do
  defmodule AntlPhonenumber.Ecto.Changeset do
    @moduledoc """
    A few validation functions.
    """
    import Ecto.Changeset, only: [validate_change: 3]

    @spec validate_iso_country_code(Ecto.Changeset.t(), atom, binary) :: Ecto.Changeset.t()
    def validate_iso_country_code(changeset, field, iso_country_code)
        when is_binary(iso_country_code) do
      validate_change(changeset, field, fn field, value ->
        if AntlPhonenumber.get_iso_country_code!(value) == iso_country_code,
          do: [],
          else: [{field, "must be a #{iso_country_code} number"}]
      end)
    end

    @spec validate_type(Ecto.Changeset.t(), atom, atom) :: Ecto.Changeset.t()
    def validate_type(changeset, field, type) when is_atom(type) do
      validate_change(changeset, field, fn field, value ->
        case AntlPhonenumber.get_type(value) do
          {:ok, ^type} ->
            []

          {:ok, _} ->
            [{field, "must be a #{to_string(type)} number"}]

          {:error, error} when is_binary(error) ->
            [{field, error}]
        end
      end)
    end
  end
end
