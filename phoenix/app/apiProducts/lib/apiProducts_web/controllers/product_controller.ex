defmodule ApiProductsWeb.ProductController do
  use ApiProductsWeb, :controller

  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product

  action_fallback ApiProductsWeb.FallbackController

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, "index.json", products: products)
  end


  def create(conn, %{"product" => product_params}) do
    with {:ok, %Product{} = product} <- Catalog.create_product(product_params) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end


  def show(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)
    render(conn, "show.json", product: product)
  end
  
  
  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Catalog.get_product!(id)

    with {:ok, %Product{} = product} <- Catalog.update_product(product, product_params) do
      render(conn, "show.json", product: product)
    end
  end


  def delete(conn, %{"id" => id}) do
    product = Catalog.get_product!(id)

    with {:ok, %Product{}} <- Catalog.delete_product(product) do
      send_resp(conn, :no_content, "")
    end
  end

end
