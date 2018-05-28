defmodule Web.UploadService do
  @moduledoc false

  use Raxx.Server
  use Raxx.Logger

  require Logger

  alias Raxx.Request
  alias Web.FileWriter

  alias Web.Chunker

  # Handle request headers
  #
  # This callbacks receives a `Raxx.Request` struct which contains all the headers, path
  # info etc. `body: true` means that the request carries a body.
  #
  # In our case we're only interested in PUT requests with a body, sent to
  # `/uploads/:name` path.
  @impl true
  def handle_head(%Request{method: :PUT, body: true, path: ["uploads", name]}, _state) do
    Logger.debug("Initiating upload of #{name}")
    file_writer = FileWriter.new(name)

    Process.flag(:trap_exit,true)
    chunk_size=Application.get_all_env(:upload)[:download_chunk_size]
    chunker=Chunker.create("#{name}",chunk_size,&Chunker.State.example_callback/2) 
    # Empty list here means that we're not returning anything to a client yet. The state
    # is the file handler used later to write chunks of data.
    {[], %{chunker: chunker}}
  end

  # Let's return "bad request" for requests without a body.
  def handle_head(%Request{method: :PUT, body: false, path: ["uploads", _name]}, _state) do
    response(:bad_request)
    |> set_header("content-type", "text/plain")
    |> set_body("Bad request")
  end

  # Handle chunks of data
  @impl true
  def handle_data(chunk, %{chunker: chunker} = state) do
    Logger.debug(fn -> "Received #{byte_size(chunk)} byte chunk of data" end)
    #FileWriter.write_chunk(file_writer, chunk)
    Chunker.send_data(chunker,chunk)      
    # Empty list here means that we're not returning anything to the client yet. Let's
    # write each chunk to a file opened in `handle_head/2` and return the state as is.
    {[], state}
  end

  # Handle end of request
  #
  # This callback receives request "trailers", which apparently are HTTP headers sent
  # at the end of the request. I had no idea one could do that.
  @impl true
  def handle_tail(_trailers,%{chunker: chunker} = state) do
    Logger.debug(fn -> "Upload completed" end)
    # We don't really need to close the file because the process will die anyway.
    #FileWriter.close(file_writer)
    # We're finally returning the response. We don't need to return state here anymore
    # because no callback related to current request will be ever called again.
    case Chunker.flush_and_terminate(chunker) do
      :ok ->
        response(:no_content)

      :fail ->
        response(:internal_server_error)
    end
  end
end
