use Mix.Config

config :riak_core,
  node: 'dev4@127.0.0.1',
  web_port: 8498,
  handoff_port: 8499,
  ring_state_dir: 'data/dev4.ring',
  platform_data_dir: 'data/dev4.data'

# config :lager,
#   handlers: [
#     lager_console_backend: :debug,
#   ]
