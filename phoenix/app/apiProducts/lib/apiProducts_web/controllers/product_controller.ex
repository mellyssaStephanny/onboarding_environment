defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller
    
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  
  plug :find_product when action in [:show, :update, :delete]

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"product" => product_params}) do
    case Catalog.create_product(product_params) do
      {:ok, %Product{} = product} ->
        conn
        |> put_status(:created)
        |> render("show.json", product: product)
      _ -> "Condition were not satisfied"
    end
  end

  def show(conn, _params) do
    render(conn, "show.json", product: conn.assigns[:product])
  end
    
  def update(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- conn.assigns[:find_product],
    {:ok, %Product{} = update_product} <- Catalog.update_product(product, product_params) do 
      render(conn, "show.json", product: update_product)
    end 
  end

  def delete(conn, _id) do
    with {:ok, %Product{} = product} <- conn.assigns[:find_product],
    {:ok, %Product{}} <- Catalog.delete_product(product) do 
      send_resp(conn, :no_content, "")
    end
  end

  defp find_product(conn, _opts) do 
    id = conn.params["id"]
    product = Catalog.get_product(id)

    if product do 
      assign(conn, :product, product)
    else 
      send_resp(conn, :not_found, "Product not found")
    end
  end
end