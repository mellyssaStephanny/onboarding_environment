defmodule ApiProductsWeb.Plugs.PlugCacheId do 

  import Plug.Conn
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product

  def init(props) do
    props 
  end
  
  # plug for cache redis 
  def get_cache(conn, id) do
    case Catalog.get_product(id) 
      nil ->
        conn 
        |> Plug.Conn.halt()
        |> send_resp(:not_found, "")
      product -> 
        assing(conn, :product, product)
    end 
  end 
end 