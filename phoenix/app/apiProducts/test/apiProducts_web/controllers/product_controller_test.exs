defmodule ApiProductsWeb.ProductControllerTest do
  use ApiProductsWeb.ConnCase, async: true

  import Mock
  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product
  alias ApiProducts.Catalog.IndexProduct

  @create_attrs %{
    amount: 42,
    description: "some description",
    name: "some name",
    price: 120.5,
    sku: "some sku"
  }
  @update_attrs %{
    amount: 43,
    description: "some updated description",
    name: "some updated name",
    price: 456.7,
    sku: "some updated sku"
  }
  @invalid_attrs %{amount: nil, description: nil, name: nil, price: nil, sku: nil}

  def fixture(:product) do
    {:ok, product} = Catalog.create_product(@create_attrs)
    product
  end

  setup %{conn: conn} do
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
    test "renders product when data is valid", %{conn: conn}
      with_mock IndexProduct,
        create_product: fn
          _produxt_params -> {:ok, 201}
        end do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)
      assert %{"id" => id} = json_response(conn, 200)["product"]

      assert Catalog.get_product(id) != nil
      assert_called(IndexProduct.create_product(@create_attrs))

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
      conn = delete(conn, Routes.product_path(conn, :delete, product))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.product_path(conn, :show, product))
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
