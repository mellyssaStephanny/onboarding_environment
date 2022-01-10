defmodule ApiProductsWeb.Services.Product do
  
  alias ApiProducts.Cache 
  alias ApiProducts.Catalog
  alias ApiProducts.IndexProduct 

  def fetch_all(params) do
    IndexProduct.search_product(params)
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

  def create(_params), do: {:error, %{code: 422, message: "Unable to create product"}}

  def update(product, product_params) do
    IO.inspect(product)
    case Catalog.update_product(product, product_params) do
      {:ok, _} = update_product ->
        Cache.set(product.id, product)
        IndexProduct.product_index(update_product)
        update_product
      error -> error
    end
  end

  def update(_product, _params), do: {:error, %{code: 422, message: "Unable to update product"}}   

  def show(product) do 
    product 
  end

  def show(), do {:error, %{code:422, message: "Could not show product"}}

  def delete(product) do
    case Catalog.delete_product(product) do 
      {:ok, _} ->
        Cache.delete(product.id)
        IndexProduct.delete_product(product)
        {:ok, :no_content}
      error -> error
    end
  end 

  def delete(), do {:error, %{code: 422, message: "Unable to delete the product"}

end