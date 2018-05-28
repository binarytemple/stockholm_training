defmodule Upload.DownloadService do
  @moduledoc false

  use Raxx.Server
  use Raxx.Logger

  require Logger

  alias Raxx.Request
  alias Upload.FileReader

  # Handle request headers
  @impl true
  def handle_head(%Request{method: :GET, path: ["uploads", name]}, _state) do
    case FileReader.new(name) do
      {:ok, file_reader} ->
        Logger.debug("Initiating download of #{name}")
        send_chunk()

        # Set response status and content type, but set body to `true`. Actual data
        # will be sent in chunks later.
        response =
          response(:ok)
          |> set_header("content-type", "application/octet-stream")
          |> set_body(true)

        {[response], file_reader}

      {:error, reason} ->
        Logger.debug("Failed to initiate download of #{name}: #{inspect(reason)}")

        # Return "not found" if we can't find such file.
        response(:not_found)
        |> set_header("content-type", "text/plain")
        |> set_body("Not found")
    end
  end

  @impl true
  def handle_info(:send_chunk, file_reader) do
    # Read next chunk of data.
    case FileReader.read_chunk(file_reader) do
      {file_reader, chunk} ->
        Logger.debug(fn -> "Sending #{byte_size(chunk)} byte chunk of data" end)
        send_chunk()
        # Send a chunk to the client.
        {[data(chunk)], file_reader}

      :eof ->
        Logger.debug("Download completed")
        FileReader.close(file_reader)
        # Indicate that the response is complete. Unfortunately we can't return `tail()`
        # only here, that's Raxx strange limitation when you call `set_body(true)`.
        {[tail()], file_reader}
    end
  end

  ## Helpers

  @spec send_chunk() :: :ok
  defp send_chunk() do
    send(self(), :send_chunk)
  end
end
