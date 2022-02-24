defmodule ApiProductsWeb.Services.Product do

  alias ApiProducts.Cache
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct

  def fetch_all(params) do
    case IndexProduct.search_product(params) do
      {:ok, products} -> products
      {:error, _} -> Product.list()
    end
  end

  def create(product) do
    case Product.create(product) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.put_product(product)

        result

      error -> error
    end
  end

  def update(product, product_params) do
    case Product.update(product, product_params) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.put_product(product)

        result

      error -> error
    end
  end

  def delete(product) do
    case Product.delete(product) do
      {:ok, _} ->
        Cache.delete(product.id)
        IndexProduct.delete_product(product)

        {:ok, :no_content}

      error -> error
    end
  end
end
