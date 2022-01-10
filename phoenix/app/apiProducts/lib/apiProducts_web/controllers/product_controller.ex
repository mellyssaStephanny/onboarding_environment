defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Cache
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  alias ApiProductsWeb.Services.Product
  
  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    case Product.fetch_all(conn.params) do
      {:ok, products} -> render(conn, "index.json", product: products)
      error -> error
  end

  def create(_conn, product_params) do
    Product.create(product_params)
  end

  def show(conn, _params) do
    Product.show(conn.assigns[:product])
  end
    
  def update(conn, _params) do
    Product.update(conn.assigns[:product], params)
  end

  def delete(conn, _params) do
    Product.delete(conn.assigns[:product])
    {:ok, :no_content}
end