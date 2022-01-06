defmodule ApiProducts.IndexProduct do

  import Tirexs.HTTP

  def product_index({:ok, product}) do
    product_json =
       %{
        id: product.id,
        name: product.name,
        sku: product.sku,
        description: product.description,
        qtd: product.qtd,
        price: product.price
        date: DateTime.to_iso8601(DateTime.utc_now())
      }
  end

  def products(product) do 
    put("/apiProducts/products/#{product_json.id}", product_json)
  end 

  def delete_product(product) do
    delete("/apiProducts/products/#{product.id}")
  end

  def search_product(params) do
    query = Enum.map_join(params, "*&", fn {k, v} -> "#{k}:#{v}" end)
    "apiProducts/products/_search#{if query != "", do: "?q="}#{query}"
    |> get()
    |> format_response()
  end

  defp format_response(any), do: {:error, any}

  defp format_response({:ok, 200}), do: {:ok, []}
end