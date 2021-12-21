defmodule AntlPhonenumber.MixProject do
  use Mix.Project

  @version "0.1.0"
  @url "https://github.com/annatel/antl_phonenumber"

  def project do
    [
      app: :antl_phonenumber,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:elixir_make] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      description: description(),
      aliases: aliases(),
      # Docs
      name: "AntlPhonenumber",
      source_url: @url,
      homepage_url: @url,
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.4", only: :test},
      {:elixir_make, "~> 0.6", runtime: false}
    ]
  end

  defp aliases() do
    [
      "app.version": &display_app_version/1
    ]
  end

  defp version(), do: @version
  defp display_app_version(_), do: Mix.shell().info(version())

  defp description do
    "An Elixir Google PhoneNumber library client"
  end

  defp package do
    [
      files: ~w(
        lib
        .formatter.exs
        mix.exs
        README.md
        LICENSE
        cpp_src
        Makefile*
      ),
      name: "antl_phonenumber",
      licenses: ["MIT"],
      links: %{
        "GitHub" => @url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: docs_extras(),
      source_ref: "v#{@version}",
      source_url: @url
    ]
  end

  defp docs_extras do
    [
      "README.md": [title: "Readme"],
      "CHANGELOG.md": []
    ]
  end
end
