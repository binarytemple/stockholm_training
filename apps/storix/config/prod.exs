use Mix.Config

config :riak_core,
  node: 'prod@127.0.0.1',
  web_port: 8098,
  handoff_port: 8099,
  ring_state_dir: 'data/prod.ring',
  platform_data_dir: 'data/prod.data'

