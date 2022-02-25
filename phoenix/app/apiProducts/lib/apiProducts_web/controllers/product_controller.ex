defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Services.Product
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Cache

  action_fallback ApiProductsWeb.FallbackController

  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  def fetch_all(params) do
    case IndexProduct.search_product(params) do
      {:ok, products} -> products
      {:error, 422} -> {:ok, Product.list()}
    end
  end

  def create(_conn, %{"product" => product_params}) do
    case Product.create(product_params) do
      {:ok, %Product{} = product} ->
        {:created, product}
      error ->
        error
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
        IndexProduct.delete_product(product.id)

        {:ok, :no_content}
    end
  end
end
