defmodule AntlPhonenumber.Nif do
  @on_load :init

  @nif_path "priv/antl_phonenumber_nif"
  def init do
    path = Application.app_dir(:antl_phonenumber, @nif_path) |> String.to_charlist()

    :ok = :erlang.load_nif(path, 0)
  end

  def format(_number, _format, _ref_country_code), do: exit(:nif_not_loaded)
  def get_type(_number, _ref_country_code), do: exit(:nif_not_loaded)
  def get_country_prefix(_number, _ref_country_code), do: exit(:nif_not_loaded)
  def to_country_code(_country_prefix), do: exit(:nif_not_loaded)
  def is_valid(_number, _ref_country_code), do: exit(:nif_not_loaded)
  def is_possible(_number, _ref_country_code), do: exit(:nif_not_loaded)
  def get_plus_e164_example(_country_code, _type), do: exit(:nif_not_loaded)
end
