defmodule ApiProducts.Cache do
  @conn :redis_server

  def set(key, value, time) do
    with value_binary <- :erlang.term_to_binary(value),
         value_encoded <- Base.encode16(value_binary),
         "OK" <- (@conn, ["SET", key, value_encoded]),
         "1" <- (@conn, ["EXPIRE", key, time]) do
      :ok
    else
      _ -> :error
    end
  end 

  def get(key), do: decode(Redix.command(@conn, ["GET", key]))

  def delete(key), do: Redix.command(@conn, ["DEL", key])

  defp encode(value) do
    value
    |> :erlang.term_to_binary()
    |> Base.encode16()
  end

  defp decode({:ok, val}) do
    {:ok, bin} = Base.decode16(val)
    {:ok, :erlang.binary_to_term(bin)}
  end
end