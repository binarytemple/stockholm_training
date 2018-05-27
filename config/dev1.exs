use Mix.Config

config :riak_core,
  node: 'dev1@127.0.0.1',
  web_port: 8198,
  handoff_port: 8199,
  ring_state_dir: 'data1/ring',
  platform_data_dir: 'data1/data'

  # config :lager,
  #   handlers: [
  #     lager_console_backend: :debug,
  #   ]
