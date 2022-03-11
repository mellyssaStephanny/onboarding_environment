defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Services.Product
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Cache

  action_fallback(ApiProductsWeb.FallbackController)

  plug(ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete])

  def index(conn, params) do
    case IndexProduct.search_product(params) do
      {:ok, products} -> json(conn, products)
      {:error, 422} -> {:error, "Bad Request"}
    end
  end

  def create(_conn, %{"product" => product_params}) do
    case Product.create(%Product{}, product_params) do
      {:ok, %Product{} = product} ->
        {:ok, :created, product}

      {:error, error} ->
        {:error, error}
    end
  end

  def update(conn, id) do
    product = Product.get(id)

    case Product.update(product, product_params) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.put_product(product)

        result

      {:error, error} ->
        {:error, error}
    end
  end

  def delete(conn, id) do
    product = conn.assigns[:product]

    case Product.delete(product) do
      {:ok, _} ->
        {:ok, :no_content}

      _ ->
        {:error, :not_found}
    end
  end

  def show(conn, %{"id" => _id}), do: {:ok, conn.assigns[:product]}
end
