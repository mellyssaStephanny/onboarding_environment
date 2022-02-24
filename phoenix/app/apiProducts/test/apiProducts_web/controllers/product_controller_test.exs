defmodule ApiProductsWeb.ProductControllerTest do
  use ApiProductsWeb.ConnCase, async: true

  import Mock

  alias ApiProducts.{Cache, IndexProduct, Repo}
  alias ApiProducts.Catalog.Product

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
  @expected_attrs %{
    id: "61f161dbd448f703274c5d39",
    qtd: 19,
    description: "expected description",
    name: "expected name",
    price: 157.9,
    sku: "sku-expected",
    barcode: "0102030405"
  }
  @invalid_attrs %{qtd: nil, description: nil, name: nil, price: nil, sku: nil, barcode: nil}

  def fixture(:product) do
    {:ok, product} = Product.create(@create_attrs)
    product
  end

  setup %{conn: conn} do
    Repo.delete_all(Product)
    Cache.flush()
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    test "lists all products", %{conn: conn} do
      with_mock(Tirexs.HTTP, get: fn _index -> {:ok, 200, %{hits: %{hits: [%{_source: @expected_attrs}]}}} end) do

        conn
        |> get(Routes.product_path(conn, :index))
        |> json_response(200)

        assert_called(Tirexs.HTTP.get("api-products/products/_search"))
      end
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      with_mock(IndexProduct, put_product: fn _produxt_params -> {:ok, 201} end) do

        response = post(conn, Routes.product_path(conn, :create), product: @create_attrs)
        #json_response(201)

        expected_product = Product.get_by_sku(@create_attrs.sku)
        require IEx; IEx.pry()
        sku = expected_product.sku

        #assert %{"sku" => @create_attrs.sku} = response["product"]
        #assert %{"sku" => @create_attrs.sku} = json_response(conn, 200)["product"]

        #assert expected_product != nil

        #assert Product.get_by_sku(sku) != nil
        assert_called(IndexProduct.put_product(@create_attrs))
      end
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @create_attrs)
      assert json_response(conn, 201)["errors"] != %{
        "sku" => ["can't be blank"],
        "qtd" => ["can't be blank"],
        "name" => ["can't be blank"],
        "price" => ["can't be blank"],
        "barcode" => ["can't be blank"],
        "description" => ["can't be blank"]
      }
    end

    test "return invalid params", %{conn: conn} do
      conn = post(conn, Routes.product_path(conn, :create), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] == %{
        "sku" => ["can't be blank"],
        "qtd" => ["can't be blank"],
        "name" => ["can't be blank"],
        "price" => ["can't be blank"],
        "barcode" => ["can't be blank"],
        "description" => ["can't be blank"]
      }
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: _id} = product}  do
      with_mock(IndexProduct, put_product: fn _produxt_update -> {:ok, 201} end) do
        conn = put(conn, Routes.product_path(conn, :update, product), product: @update_attrs)

        assert %{"id" => id} = json_response(conn, 200)["product"]

        assert Product.get(id) != nil
        assert_called(IndexProduct.put_product(@update_attrs))
      end
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, Routes.product_path(conn, :update, product), product: @invalid_attrs)
      assert json_response(conn, 422)["errors"] == %{
        "sku" => ["can't be blank"],
        "qtd" => ["can't be blank"],
        "name" => ["can't be blank"],
        "price" => ["can't be blank"],
        "barcode" => ["can't be blank"],
        "description" => ["can't be blank"]
      }
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      with_mock(IndexProduct, delete_product: fn _delete_by_id -> {:ok, 201} end) do
        conn
        |> delete(Routes.product_path(conn, :delete, product))
        |> response(204)

        assert Product.get(product.id) == nil
        assert_called(IndexProduct.delete_product(product))
      end
    end
  end

  describe "show product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id}} do
      conn = get(conn, Routes.product_path(conn, :show, id))

      expected_product = %{
        "id" => id,
        "qtd" => 42,
        "description" => "some description",
        "name" => "some name",
        "price" => 120.5,
        "sku" => "some-sku",
        "barcode" => "123456789"
      }

      assert json_response(conn, 200)["product"] == expected_product
    end

    test "renders product when data is invalid", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :show, id = "61e580fc6057a40203db022e"))
      response(conn, 404)
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end
end
