defmodule ApiProductsWeb.Plugs.PlugCacheId do
  import Plug.Conn

  alias ApiProducts.Cache
  alias ApiProducts.Catalog.Product

  def init(props) do
    props
  end

  # plug for cache redis
  def call(conn, _opts) do
    id = conn.params["id"]

    case Cache.get(id) do
      {:ok, product} ->
        assign(conn, :product, product)

      _ ->
        case Product.get(id) do
          nil ->
            conn
            |> halt()
            |> send_resp(:not_found, "")

          product ->
            Cache.set(product.id, product)
            assign(conn, :product, product)
        end
    end
  end
end
