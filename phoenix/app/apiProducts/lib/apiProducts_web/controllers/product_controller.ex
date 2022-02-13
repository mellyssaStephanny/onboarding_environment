defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Catalog.Product, as: CatalogProduct
  alias ApiProductsWeb.Services.Product

  action_fallback ApiProductsWeb.FallbackController

  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  def index(conn, params) do
    products = Product.fetch_all(params)
    render(conn, "index.json", products: products)
  end

  def create(_conn, %{"product" => product_params}) do
    case Product.create(product_params) do
      {:ok, %CatalogProduct{} = product} -> product
      error -> error
    end
  end

  def create(_conn, _params) do
    {:error, "Product key required"}
  end

  def show(conn, _) do
    conn.assigns[:product]
  end

  def update(conn, %{"product" => product_params}) do
    Product.update(conn.assigns[:product], product_params)
  end

  def update(_conn, _params) do
    {:error, "Could not update product because key is required"}
  end

  def delete(conn, %{"id" => _id}) do
    Product.delete(conn.assigns[:product])
  end
end
