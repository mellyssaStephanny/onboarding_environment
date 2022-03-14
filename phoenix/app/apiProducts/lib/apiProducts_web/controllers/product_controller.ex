defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Services.Product
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Cache

  action_fallback(ApiProductsWeb.FallbackController)

  plug(ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete])

  def index(conn, _) do
    list = Product.list()
    conn |> put_status(200) |> json(list)
  end

  def create(_conn, %{"product" => product_params}) do
    case Product.create(%Product{}, product_params) do
      {:ok, %Product{} = product} ->
        IndexProduct.put_product(product)
        {:ok, :created, product}

      {:error, error} ->
        {:error, error}
    end
  end

  def update(conn, %{"sku" => sku} = params) do
    product = Product.get_by_sku(sku)

    case Product.update(product, params) do
      {:ok, product} = result ->
        Cache.set(product.id, product)
        IndexProduct.put_product(product)

        result

      {:error, :not_found} ->
        {:error, "Product not found"}

      {:error, error} ->
        {:error, error}
    end
  end

  def delete(conn, %{"sku" => sku}) do
    case Product.delete_by_sku(sku) do
      {:ok, _} ->
        conn |> put_status(200) |> json(%{"message" => "Product successfully deleted"})

      {:error, :not_found} ->
        {:error, "Produtct not found"}

      _ ->
        {:error, "Unidentified error"}
    end
  end

  def show(conn, %{"sku" => sku}) do
    case Product.get_by_sku(sku) do
      nil ->
        {:error, "Product not found"}

      product ->
        resp = Product.format_product(product)
        conn |> put_status(200) |> json(resp)
    end
  end
end
