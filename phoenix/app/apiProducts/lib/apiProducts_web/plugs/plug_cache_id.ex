defmodule ApiProductsWeb.Plugs.PlugCacheId do 
  import Plug.Conn

  alias ApiProducts.Cache
  alias ApiProducts.Catalog

  def init(props) do
    props 
  end
  
  # plug for cache redis 
  def get_cache(conn, id) do
    id = conn.params["id"]
    case Cache.get(conn, id) do
      nil ->
        conn 
        |> halt()
        |> send_resp(:not_found, "")
      product -> 
        assing(conn, :product, product)
      _ ->
        case Catalog.get_product(id) do
          Cache.set(id, product)
          assign(conn, :product, product)
        _ ->
    end 
  end 
end 