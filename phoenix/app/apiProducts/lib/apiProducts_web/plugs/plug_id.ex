defmodule ApiProductsWeb.Plugs.PlugId do
  import Plug.Conn

  alias ApiProducts.Catalog

  def init(opts), do: opts
  
  # plug for find product by id
  def call(conn, _opts) do
    id = conn.params["id"]
    product = Catalog.get_product(id)
    if product do 
      assign(conn, :product, product)
    else
      conn 
      |> send_resp(404, "")
      |> halt()
    end 
  end  
end 

  





