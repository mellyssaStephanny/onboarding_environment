defmodule ApiProducts.IndexProduct do

  import Tirexs.HTTP
  alias ApiProducts.Catalog

    def product_index({:ok, product}) do
    product_json =
       %{
        id: product.id,
        name: product.name,
        sku: product.sku,
        description: product.description,
        qtd: product.qtd,
        price: product.price
        last_update_at: DateTime.to_iso8601(DateTime.utc_now())
      }

    put("/apiProducts/products/#{product_json.id}", product_json)
  end

  def delete_product_by_index(product) do
    delete("/apiProducts/products/#{product.id}")
  end
end