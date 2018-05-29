use Mix.Config

config :riak_core,
  node: 'dev2@127.0.0.1',
  web_port: 8298,
  handoff_port: 8299,
  ring_state_dir: 'data/dev2.ring',
  platform_data_dir: 'data/dev2.data'

# config :lager,
#   handlers: [
#     lager_console_backend: :debug,
#   ]
