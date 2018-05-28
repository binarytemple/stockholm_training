defmodule Imageer.UploadHandler do
  import Logger
  alias Imageer.Chunker

  def init(_type, req, opts) do
    debug("#{__MODULE__} called with init #{inspect(opts)}")
    {:ok, req, :no_state}
  end

  # @read_length 512
  @load_length 512

  @request_args [
    {:length, @load_length}
  ]

  def handle(request, state) do
    if :cowboy_req.has_body(request) do

      p = Chunker.create("foo", 1024, &Chunker.State.example_callback/2)

      gen_stream(request)
      |> Stream.each(fn data -> Chunker.send_data(p, data) end)
      |> Enum.to_list()

       case Chunker.flush_and_terminate(p) do
        :ok ->
           {:ok, resp} =
            :cowboy_req.reply(200, [{"content-type", "text/plain"}], "successfull upload!", request)
          {:ok, resp, state}
        :fail ->
           {:ok, resp} =
            :cowboy_req.reply(400, [{"content-type", "text/plain"}], "failed upload!", request)
          {:ok, resp, state}
       end
    end
  end

  def terminate(_Reason, _Req, _State) do
    :ok
  end

  def stream_body(req0, acc, chunk_args \\ @request_args) do
    case :cowboy_req.body(req0, chunk_args) do
      {:ok, data, req} ->
        {:ok, <<acc::bitstring, data::bitstring>>, req}

      {:more, data, req} ->
        stream_body(req, <<acc::bitstring, data::bitstring>>)

      {:error, _reason} ->
        {:ok, "final", req0}
    end
  end

  def gen_stream(request) do
    Stream.resource(
      fn -> request end,
      fn request ->
        case :cowboy_req.body(request, [
               {:length, @load_length}
             ]) do
          {:ok, "", request} ->
            {:halt, request}

          {:ok, data, request} when is_binary(data) ->
            {[data], request}

          {:more, data, request} ->
            {[data], request}

          _x ->
            {:halt, request}
        end
      end,
      fn _ -> nil end
    )
  end
end
