defmodule Web.Mixfile do
  use Mix.Project
  def project do
    [
      app: :web,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
	  # umbrella stuff
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      deps: deps(),
    ]
  end
  def application do
    [
      mod: {Web.Application, []},
      extra_applications: [:logger_lager_backend]
    ]
  end
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
  defp deps do
    [
      {:ace     , "~> 0.16"  } ,
      {:raxx    , "~> 0.15"  } ,
      {:gen_state_machine    , "~> 2.0"   } ,
    ]
  end
  defp aliases do
    [
    ]
  end
end
