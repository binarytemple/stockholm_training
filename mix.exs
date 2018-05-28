defmodule Storix.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:goldrush, [ git: "git@github.com:freeakdb/goldrush.git", tag: "0.1.9",manager: :rebar3, override: true]},
      {:lager,  [ git: "git://github.com/erlang-lager/lager", tag: "3.5.2", manager: :rebar3, override: true]},
      {:logger_lager_backend , "~> 0.1.0" } ,
      {:distillery           , "~>1.5.2"  } ,
    ]
  end
end
