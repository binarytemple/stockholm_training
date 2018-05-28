defmodule Imageer.Util do
    import Logger
    
    def acumulator(payload, accumulator, size) do
      chunk = payload <> accumulator
      case chunk do
        <<ready::binary-size(size), rest::binary>> ->
          debug("full")
          [:full, ready, rest]
        _ ->
          debug("accumulate")
          [:acc, chunk]
      end
    end
  end