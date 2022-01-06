defmodule ApiProductsWeb.Services.Product do 
  
  alias ApiProducts.Cache 
  alias ApiProducts.Catalog
  alias ApiProducts.IndexProduct 

  def fetch_all() do
    products = Catalog.list_products()
    {:ok, products}
  end

  def create(product) when is_map(product) do
    case Catalog.create_product(product) do
      {:ok, _} = product ->
        Cache.set(product.id, result)
        IndexProduct.product_index(product)
        product
      error -> error
    end
  end

  def update(product, %{"product" => product_params} ) do
    case Catalog.update_product(product, product_params) do
      {:ok, _} = update_product ->
        Catalog.update_product(product)
        IndexProduct.product_index(update_product)
        update_product
      error -> error
    end
  end

  def delete(product) do
    case Catalog.delete_product(product) do 
      Cache.delete(product.id)
      IndexProduct.delete_product(product)
    end
  end
end