defmodule ApiProductsWeb.Services.Product do

  alias ApiProducts.Cache 
  alias ApiProducts.Catalog
  alias ApiProducts.IndexProduct 

  def fetch_all(params) do
    case IndexProduct.search_product(params) do
      {:ok, products} -> products
      {:error, _} -> Catalog.list_products()
    end
  end

  def create(product) do
    case Catalog.create_product(product) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.update_product(product)

        result

      error -> error
    end
  end

  def update(product, product_params) do
    case Catalog.update_product(product, product_params) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.update_product(product)

        result

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