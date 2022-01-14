defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Catalog.Product
  alias ApiProductsWeb.Services.Product

  action_fallback ApiProductsWeb.FallbackController
  
  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  def index(conn, _params) do
    Product.fetch_all(conn.assigns[:product_params])
  end

  def create(conn, "product" => product_params) do
    Product.create(conn.assigns[:product_params])
  end

  def show(conn, _) do
    conn.assigns[:product]
  end
    
  def update(conn, _) do
    Product.update(conn.assigns[:product], conn.assingns[:product_params])
  end

  def delete(conn, _params) do
    Product.delete(conn.assigns[:product])
  end
end