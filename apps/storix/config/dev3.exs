use Mix.Config

config :riak_core,
  node: 'dev3@127.0.0.1',
  web_port: 8398,
  handoff_port: 8399,
  ring_state_dir: 'data/dev3.ring',
  platform_data_dir: 'data/dev3.data'

# config :lager,
#   handlers: [
#     lager_console_backend: :debug,
#   ]
