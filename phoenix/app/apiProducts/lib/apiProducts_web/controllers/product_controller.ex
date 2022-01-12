defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Cache
  alias ApiProducts.Catalog
  alias ApiProductsWeb.Services.Product
  
  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]
  plug ApiProductsWeb.Plugs.PlugShowProduct when action in [:create, :update]

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    case Product.fetch_all(conn.params) do
      {:ok, products} -> render(conn, "index.json", product: products)
      error -> error
    end
  end

  def create(conn, _) do
    Product.create(conn.assigns[:product_params])
  end

  def show(conn, _) do
    conn.assigns[:product]
  end
    
  def update(conn, _) do
    Product.update(conn.assigns[:product], params)
  end

  def delete(conn, _params) do
    Product.delete(conn.assigns[:product])
    {:ok, :no_content}
  end
end