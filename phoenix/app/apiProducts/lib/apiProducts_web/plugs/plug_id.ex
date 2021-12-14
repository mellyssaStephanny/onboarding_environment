defmodule ApiProductsWeb.Plugs.PlugId do
  import Plug.Conn

  alias ApiProducts.Catalog

  def get_product(conn, _opts), do: product_id(conn, conn.params["id"])
  
  defp product_by_id(conn, nil), do: assign(conn, :get_product, {:error, :bad_request})

  defp product_by_id(conn, id) do
    with product <- Catalog.get_product!(id),
         true <- product != nil do
      assign(conn, :get_product, {:ok, product})
    else
      _ -> assign(conn, :get_product, {:error, :not_found})
    end
  end
end