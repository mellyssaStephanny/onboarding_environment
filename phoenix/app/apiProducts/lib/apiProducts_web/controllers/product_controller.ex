defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Services.Product
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Cache

  action_fallback ApiProductsWeb.FallbackController

  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  def index(conn, params) do
    case IndexProduct.search_product(params) do
      {:ok, products} -> json(conn, products)
      {:error, 422} -> {:error, "Bad Request"}
    end
  end

  def create(_conn, %{"product" => product_params}) do
    # IO.inspect(product_params)
    case Product.create(%Product{}, product_params) do
      {:ok, %Product{} = product} ->
        {:ok, :created, product}

      {:error, error} ->
        {:error, error}
    end
  end

  def update(id, product_params) do
    product = Product.get(id) |> Repo.one()

    case Product.update(product, product_params) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.put_product(product)

        result

      {:error, error} ->
        {:error, error}
    end
  end

  def delete(id) do
    case Product.delete(id) do
      {:ok, _} ->
        Cache.delete(id)
        IndexProduct.delete_product(id)

        {:ok, :no_content}
    end
  end

  def show(conn, %{"id" => _id}), do: {:ok, conn.assigns[:product]}
end
