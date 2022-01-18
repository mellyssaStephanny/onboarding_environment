defmodule ApiProducts.IndexProduct do

  import Tirexs.HTTP

  def update_product(product) do
    product_json =
       %{
        id: product.id,
        name: product.name,
        sku: product.sku,
        description: product.description,
        qtd: product.qtd,
        price: product.price,
        date: DateTime.to_iso8601(DateTime.utc_now())
      }

    put("/api-products/products/#{product_json.id}", product_json)
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