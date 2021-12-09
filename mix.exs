defmodule Mix.Tasks.Compile.AntlPhonenumber do
  def run(_) do
    {result, _error_code} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.shell().info(result)
    :ok
  end
end

defmodule AntlPhonenumber.MixProject do
  use Mix.Project

  def project do
    [
      app: :antl_phonenumber,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:antl_phonenumber, :elixir, :app],
      elixirc_paths: elixirc_paths(Mix.env())
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
      {:ecto, "~> 3.4", only: :test}
    ]
  end
end
