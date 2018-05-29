use Mix.Config

config :riak_core,
  node: 'dev5@127.0.0.1',
  web_port: 8598,
  handoff_port: 8599,
  ring_state_dir: 'data/dev5.ring',
  platform_data_dir: 'data/dev5.data'

# config :lager,
#   handlers: [
#     lager_console_backend: :debug,
#   ]
