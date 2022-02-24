defmodule ApiProducts.IndexProduct do

  import Tirexs.HTTP

  def put_product(product) do
    require IEx; IEx.pry()
    put("api-products/products/#{product.id}", format_json(product))
  end

  defp format_json(product) do
    %{
      id: product.id,
      sku: product.sku,
      qtd: product.qtd,
      name: product.name,
      price: product.price,
      barcode: product.barcode,
      description: product.description,
      date: DateTime.to_iso8601(DateTime.utc_now())
    }
  end

  def delete_product(product) do
    delete("/api-products/products/#{product.id}")
  end

  def search_product(params) do
    query = Enum.map_join(params, "%20AND%20", fn {k, v} -> "#{k}:#{v}" end)

    "api-products/products/_search#{if query != "", do: "?q="}#{query}"
    |> get()
    |> format_response()
  end

  defp format_response({:ok, 200, %{hits: %{hits: hits}}}),
    do: {:ok, Enum.map(hits, & &1._source)}

  defp format_response({:error, 404, _result}), do: {:error, "Not found"}
end
