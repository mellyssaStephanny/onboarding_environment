defmodule ApiProductsWeb.Plugs.PlugCacheId do 

  import Plug.Conn
  alias ApiProducts.Catalog

  def init(props) do
    props 
  end
  
  # plug for cahe redis 
  def get_cache(id) do
    id = conn.params["id"]
    case Cache.get(id) do 
      {:ok, _} = result ->
        result 
      _-> 
      product = Catalog.get_product(id)
      if product do 
        Cache.set(id, product)
        {:ok, product}
      else 
        conn 
        |> put_status(:not_found)
        |> render(:"404")
        |> halt()
      end 
    end 
  end 