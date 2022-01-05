defmodule ApiProductsWeb.Plugs.PlugCacheId do 

  import Plug.Conn
  alias ApiProducts.Catalog

  def init(props) do
    props 
  end

  def call(conn, _params) do 
    get_product(conn)
  end 

  def get_cache(id) do
    case Cache.get(id) do 
      {:ok, _} = result ->
        resulkt 
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