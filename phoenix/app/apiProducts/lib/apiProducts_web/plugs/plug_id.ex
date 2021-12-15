defmodule ApiProductsWeb.Plugs.PlugId do
  import Plug.Conn

  alias ApiProducts.Catalog
  
  # plug for find product by id
  defp find_product(conn, id) do
    id = conn.params["id"]
    product = Catalog.get_product(id)
    if product do 
      assign(conn, :product, product)
    else 
      send_resp(conn, 404, "Product not found")
    end 
  end  
end 

  





