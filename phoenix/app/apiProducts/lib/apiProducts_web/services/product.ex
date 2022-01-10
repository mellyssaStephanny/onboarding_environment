defmodule ApiProductsWeb.Services.Product do
  
  alias ApiProducts.Cache 
  alias ApiProducts.Catalog
  alias ApiProducts.IndexProduct 

  def fetch_all(params) do
    ProductIndex.search_product(product)
    case ProductIndex.search_product(product) do 
      {:elsk, products} -> products
      {:mongodb, products} -> products
      error -> error
    end
  end

  def create(product) when is_map(product) do
    case Catalog.product_index(product) do
      {:ok, product} ->
        Cache.set(product.id, product)
        IndexProduct.product_index(product)
        product
      error -> error
    end
  end

  def update(product, product_params) do
    case Catalog.update_product(product, product_params) do
      {:ok, _} = update_product ->
        Cache.set(product.id, product)
        IndexProduct.product_index(update_product)
        update_product
      error -> error
    end
  end

  def delete(product) do
    case Catalog.delete_product(product) do 
      {:ok, _} ->
        Cache.delete(product.id)
        IndexProduct.delete_product(product)
        {:ok, :no_content}
      error -> error
    end
  end  
end