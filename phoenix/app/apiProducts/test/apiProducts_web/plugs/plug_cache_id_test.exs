defmodule ApiProductsWeb.Plugs.PlugCacheIdTest do
  use ApiProductsWeb.ConnCase, async: false

  import Mock

  alias ApiProductsWeb.Catalog
  alias ApiProductsWeb.Plugs.PlugCacheId

  setup_all do
    %{
      attrs: %{
        id: "id_expected",
        id_invalid: "id_invalid",
        product: "product_expected"
      }
    }
  end

  describe "plug cache" do
    test "return error if product id is not found", %{conn: conn, attrs: attrs} do
      conn =
        %{conn | params: %{"id" => attrs.id}}
        |> PlugCacheId.call(attrs.id)

      assert conn.assign[:product] == nil
    end

    test "get product in cache", %{conn: conn, attrs: attrs} do
      with_mock(Catalog, get_product: fn _id -> attrs.product end) do
        conn =
          %{conn | params: %{"id" => attrs.id}}
          |> PlugCacheId.call(attrs.id)

        assert conn.assigns[:product] == attrs.product
      end
    end
  end
end
