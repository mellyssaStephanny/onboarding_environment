defmodule ApiProductsWeb.Services.Product do 
  
  alias ApiProducts.Cache 
  alias ApiProducts.Catalog
  alias ApiProducts.IndexProduct 

  def fetch_all() do
    case Cache.get("products") do
      {:ok, _} = result ->
        result
      _ ->
        products = Catalog.list_products()
        Cache.set("products", products)
        {:ok, products}
    end
  end

  def create(%{"product" => product}) when is_map(product) do
    case Catalog.create_product(product) do
      {:ok, _} = result ->
        Cache.delete("products")
        IndexProduct.product_index(result)
        result
      error -> error
    end
  end

  def update(product, %{"product" => product_params} ) do
    case Catalog.update_product(product, product_params) do
      {:ok, _} = update_product ->
        Cache.delete("products")
        IndexProduct.product_index(update_product)
        update_product
      error -> error
    end
  end

  def delete(product) do
    Catalog.delete_product(product)
    Cache.delete("products")
    IndexProduct.product_index.delete_product_by_index(product)
  end
end


