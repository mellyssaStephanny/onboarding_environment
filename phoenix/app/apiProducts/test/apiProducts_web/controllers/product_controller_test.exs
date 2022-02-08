defmodule ApiProductsWeb.ProductControllerTest do
  use ApiProductsWeb.ConnCase, async: true

  import Mock
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Repo
  alias ApiProducts.Cache

  @create_attrs %{
    qtd: 42,
    description: "some description",
    name: "some name",
    price: 120.5,
    sku: "some-sku",
    barcode: "123456789"
  }
  @update_attrs %{
    qtd: 43,
    description: "some updated description",
    name: "some updated name",
    price: 456.7,
    sku: "some-updated-sku",
    barcode: "987654321"
  }
  @invalid_attrs %{qtd: nil, description: nil, name: nil, price: nil, sku: nil, barcode: nil}

  def fixture(:product) do
    {:ok, product} = Catalog.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
    Repo.delete_all(Product)
    Cache.flush()
    {:ok, conn: put_req_header(conn, "accept", "application/json")}

  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :index))
      assert %{"products" => products} = json_response(conn, 200)

      id_return = id_products_map(list_products())
      assert id_products_map(list_products()) == id_return
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      with_mock(IndexProduct,
        create_product: fn
          _produxt_params -> {:ok, 201}
        end) do

      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)
      expected_product = Catalog.get_product_by_sku(@create_attrs[:sku])
      assert %{"id" => id} = json_response(conn, 200)["product"]

      assert Catalog.get_product(id) != nil
      assert_called(IndexProduct.create_product(expected_product))

      #conn = get(conn, Routes.product_path(conn, :show, id))
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: _id} = product} do
      with_mock IndexProduct,
        update_product: fn
          _updated_product -> {:ok, 201}
        end do
        conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)

        assert %{"id" => id} = json_response(conn, 200)["product"]

        assert Catalog.get_product(id) != nil

        assert_called(IndexProduct.update_product(@update_attrs))
      end
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do

      with_mock(IndexProduct,
        delete_product: fn
          _delete_by_id -> {:ok, 201}
        end) do
        conn = delete(conn, Routes.product_path(conn, :delete, product))
        response(conn, 204)

        assert Catalog.get_product(product.id) == nil
        assert_called(IndexProduct.delete_product(product.id))
      end
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end

  defp list_products() do
    Catalog.list_products()
  end

  defp id_products_map(products) do
    Enum.map(products, fn
      %{"id" => id} = _product -> id
      %{id: id} = _product -> id
    end)
  end
end
