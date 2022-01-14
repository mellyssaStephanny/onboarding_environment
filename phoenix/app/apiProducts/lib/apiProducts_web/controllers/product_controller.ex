defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProductsWeb.Catalog.Product
  alias ApiProductsWeb.Services.Product

  action_fallback ApiProductsWeb.FallbackController
  
  plug ApiProductsWeb.Plugs.PlugCacheId when action in [:show, :update, :delete]

  def index(conn, _params) do
    case Product.fetch_all(product) do
      render(conn, "index.json", product: product)
    end
  end

  def create(conn, %{"product" => product_params}) do
    case Product.create(product_params) do 
      {:ok, %Product{} = product}
      render(conn.assigns[:product_params])
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