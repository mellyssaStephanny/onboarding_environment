defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  alias ApiProductsWeb.Services.Product
  
  plug ApiProductsWeb.Plugs.PlugId when action in [:show, :update, :delete]

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    case Product.fetch_all() do
      {:ok, products} -> render(conn, "index.json", product: products)}
      error -> error
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product(product_params) do
      {:ok, %Product{} = product} ->
        conn
        |> put_status(:created)
        |> render("show.json", product: product)
      error -> error
    end
  end

  def show(conn, _params) do
    render(conn, "show.json", product: conn.assigns[:product])
  end
    
  def update(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- conn.assigns[:product],
    {:ok, %Product{} = update_product} <- Catalog.update_product(product, product_params) do 
      render(conn, "show.json", product: update_product)
    end 
  end

  def delete(conn, _id) do
    with {:ok, %Product{} = product} <- conn.assigns[:product],
    {:ok, %Product{}} <- Catalog.delete_product(product) do 
      send_resp(conn, :no_content, "")
    end
  end
end