defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller
  import ApiProductsWeb.PlugId
  
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product

  plug :get_product when action in [:show, :update, :delete]

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
      error ->
        error 
    end
  end


  def show(conn, %{"id" => id}) do
    case conn.assigns[:get_product] do
      {:ok, %Product{} = product} -> render(conn, "show.json", product: product)
      error -> error
    end
  end
  
  
  def update(conn, %{"id" => id, "product" => product_params}) do
    with {:ok, %Product{} = product} <- conn.assigns[:get_product],
         {:ok, %Product{} = updated_product} <- Catalog.update_product(product, product_params) do
      render(conn, "show.json", product: updated_product)
    end
  end
    

  def delete(conn, %{"id" => id}) do
    with {:ok, %Product{} = product} <- conn.assigns[:get_product]
    with {:ok, %Product{}} <- Catalog.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end

end
