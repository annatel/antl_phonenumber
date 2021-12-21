defmodule AntlPhonenumber.Nif do
  @on_load :init

  @nif_path 'antl_phonenumber_nif'
  def init do
    path = :filename.join(:code.priv_dir(:antl_phonenumber), @nif_path)

    :ok = :erlang.load_nif(path, 0)
  end

  @spec format(String.Chars.t(), String.Chars.t(), String.Chars.t()) ::
          {:ok, String.Chars.t()} | {:error, String.Chars.t()}
  def format(_number, _format, _ref_country_code), do: :erlang.nif_error(:nif_not_loaded)

  @spec get_type(String.Chars.t(), String.Chars.t()) ::
          {:ok, String.Chars.t()} | {:error, String.Chars.t()}
  def get_type(_number, _ref_country_code), do: :erlang.nif_error(:nif_not_loaded)

  @spec get_country_prefix(String.Chars.t(), String.Chars.t()) ::
          {:ok, integer} | {:error, String.Chars.t()}
  def get_country_prefix(_number, _ref_country_code), do: :erlang.nif_error(:nif_not_loaded)

  @spec to_country_code(String.Chars.t()) :: String.Chars.t()
  def to_country_code(_country_prefix), do: :erlang.nif_error(:nif_not_loaded)

  @spec is_valid(String.Chars.t(), String.Chars.t()) :: boolean()
  def is_valid(_number, _ref_country_code), do: :erlang.nif_error(:nif_not_loaded)

  @spec is_possible(String.Chars.t(), String.Chars.t()) :: boolean()
  def is_possible(_number, _ref_country_code), do: :erlang.nif_error(:nif_not_loaded)

  @spec get_plus_e164_example(String.Chars.t(), String.Chars.t()) :: String.Chars.t()
  def get_plus_e164_example(_country_code, _type), do: :erlang.nif_error(:nif_not_loaded)
end
