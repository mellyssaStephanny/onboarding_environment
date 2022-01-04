defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  alias ApiProductsWeb.Services.Product
  
  plug ApiProductsWeb.Plugs.PlugId when action in [:show, :update, :delete]

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    case Product.fetch_all() do
      {:ok, products} -> render(conn, "index.json", product: products)
      error -> error
  end

  def create(conn, product_params) do
    Product.create(product_params)
  end

  def show(conn, _params) do
    Product.show(conn.params["id"])
  end
    
  def update(conn, _params) do
    Product.update(conn.params["id"], params)
    
  end

  def delete(conn, _params) do
    Product.delete(conn.params["id"])
end