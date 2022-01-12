defmodule ApiProducts.Cache do
  @conn :redis_server

  def set(key, value) do
    bin = encode(value)
    Redix.command(@conn, ["SET", key, bin])
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

  defp decode({:ok, nil}), do: {:error, "Key not found"}
end