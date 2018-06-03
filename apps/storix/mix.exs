defmodule Storix.Mixfile do
  use Mix.Project
  require Logger


  def project do
    [app: :storix,
     version: "0.1.0",
     elixir: "~> 1.6",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
    ]
  end

  def application do
    base = [
      extra_applications: [:lager, :logger_lager_backend],
    ]

    all  = base ++ [
      # applications: [:riak_core ],
      mod: {Storix, %{env: Mix.env}}
    ]

    case Mix.env do
      :test -> base
      :dev -> base
      _  -> all
    end

  end

  defp deps do
    [
      {:leveled, [git: "https://github.com/martinsumner/leveled.git", branch: "master", runtime: false]},
      {:goldrush, [ git: "git@github.com:freeakdb/goldrush.git", tag: "0.1.9",manager: :rebar3, override: true]},
      {:lager,  [ git: "git://github.com/erlang-lager/lager", tag: "3.5.2", manager: :rebar3, override: true]},
      {:gen_state_machine    , "~> 2.0"   } ,
      {:folsom,  [ git: "git@github.com:freeakdb/folsom.git", tag: "0.8.2p1", manager: :rebar3, override: true,runtime: false ]},
      {:riak_core, git: "git@github.com:freeakdb/riak_core.git", branch: "riak_core_lite_training_bh", runtime: false},
      {:bear,  [ git: "git@github.com:freeakdb/bear.git", tag: "0.8.2p1-rebar3-otp20", manager: :rebar3, override: true,runtime: false]},
      {:cuttlefish,  [ git: "git://github.com/bryanhuntesl/cuttlefish.git", branch: "develop",  override: true, runtime: false]},
      {:getopt,  [ git: "https://github.com/freeakdb/getopt.git", tag: "r20-rebar3", manager: :rebar, override: true,runtime: false ]},
      {:gen_fsm_compat,  [ git: "https://github.com/freeakdb/gen_fsm_compat.git", branch: "elixir1.6-r20", manager: :rebar, override: true ]},
      {:clique,  [ git: "https://github.com/freeakdb/clique.git", branch: "develop-2.2", manager: :rebar, override: true,runtime: false ]},
      {:riak_sysmon,  [ git: "https://github.com/freeakdb/riak_sysmon.git", branch: "develop-2.2", manager: :rebar, override: true, runtime: false ]},
    ]
  end
end
