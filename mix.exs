defmodule NoSlides.Mixfile do
  use Mix.Project

  def project do
    [app: :no_slides,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:riak_core, :logger ],
     mod: {NoSlides, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:riak_core, git: "git@github.com:marianoguerra/riak_core.git", branch: "riak_core_lite_ng"},
      {:eleveldb,  [ git: "git@github.com:freeakdb/eleveldb.git", tag: "2.2.20", manager: :rebar3, override: true]},
      {:lager,  [ git: "git://github.com/erlang-lager/lager", tag: "3.5.2", manager: :rebar3, override: true]},
      {:goldrush, "~>0.1.8", [env: :prod, repo: "hexpm", hex: "goldrush", manager: :rebar3, override: true]},
      {:cuttlefish,  [ git: "git://github.com/bryanhuntesl/cuttlefish.git", branch: "develop",  override: true]},
      {:getopt,  [ git: "https://github.com/freeakdb/getopt.git", tag: "r20-rebar3", manager: :rebar, override: true ]},
      {:gen_fsm_compat,  [ git: "https://github.com/freeakdb/gen_fsm_compat.git", branch: "elixir1.6-r20", manager: :rebar, override: true ]},
      {:clique,  [ git: "https://github.com/freeakdb/clique.git", branch: "develop-2.2", manager: :rebar, override: true ]},
      {:riak_sysmon,  [ git: "https://github.com/freeakdb/riak_sysmon.git", branch: "develop-2.2", manager: :rebar, override: true ]},
      {:riak_ensemble,  [ git: "https://github.com/freeakdb/riak_ensemble.git", branch: "develop-2.2", manager: :rebar, override: true ]},
    ]
  end
end
