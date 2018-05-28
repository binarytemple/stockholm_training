# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# By default, the umbrella project as well as each child
# application will require this configuration file, ensuring
# they all use the same configuration. While one could
# configure all applications here, we prefer to delegate
# back to each application for organization purposes.

config :web,
  port: 8080,
  uploads_dir: "uploads",
  download_chunk_size: 5000

import_config "../apps/*/config/config.exs"
