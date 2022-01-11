defmodule ApiProductsWeb.Plugs.PlugProductParams do 
  import Plug.Conn

  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product

  def init(props) do
    props 
  end

  defp product_params(conn, _) do 
    case conn.body_params do 
      %{"product" => product_params} -> assing(conn, :product_params, product_params)
      _ ->
        conn
        |> put_status(400)
        |> json(%{error:"Unable to return the product. Check if the parameters are correct"})
        |> halt()
    end
  end
end