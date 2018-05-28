defmodule Web.NotFound do
  @moduledoc false

  use Raxx.Server

  @impl true
  def handle_request(_request, _state) do
    response(:not_found)
    |> set_header("content-type", "text/plain")
    |> set_body("Not found")
  end
end
