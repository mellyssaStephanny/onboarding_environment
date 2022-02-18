defmodule ApiProductsWeb.Plugs.PlugCacheIdTest do
  use ApiProductsWeb.ConnCase, async: false

  alias ApiProductsWeb.Plugs.PlugCacheId
  alias ApiProducts.Cache

  setup_all do
    %{
      attrs: %{
        id: "id_expected",
        id_invalid: "61f161dbd448f703274c5000",
        product: "product_expected"
      }
    }
  end

  setup do
    ApiProducts.Cache.flush()
    :ok
  end

  describe "call/2" do
    test "return error if product id is not found", %{conn: conn, attrs: attrs} do
      conn = PlugCacheId.call(%{conn | params: %{"id" => attrs.id_invalid}}, attrs.id)

      assert response(conn, 404) == ""
      assert conn.assigns[:product] == nil
    end

    test "get product in cache", %{conn: conn, attrs: attrs} do
      Cache.set(attrs.id, attrs.product)

      conn =
        %{conn | params: %{"id" => attrs.id}}
        |> PlugCacheId.call([])

      assert conn.assigns[:product] == attrs.product
    end

    test "get product not cache", %{conn: conn, attrs: attrs} do

      conn =
        %{conn | params: %{"id" => attrs.id_invalid}}
        |> PlugCacheId.call([attrs.product])

      assert conn.assigns[:product] == nil
    end
  end
end
