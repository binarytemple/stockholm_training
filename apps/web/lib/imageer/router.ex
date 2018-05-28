defmodule Imageer.Router do
  @moduledoc false

  use Raxx.Server

  use Raxx.Router, [
    {%{method: :PUT, path: ["uploads", _name]}, Imageer.UploadService},
    {_, Imageer.NotFound}
  ]
end
