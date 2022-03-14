defmodule ApiProductsWeb.ProductControllerTest do
  use ApiProductsWeb.ConnCase, async: true

  alias ApiProducts.Catalog.Product
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
    sku: "some-updated-sku",
    name: "some updated name",
    description: "some updated description",
    qtd: 43,
    price: 456.7,
    barcode: "987654321"
  }

  @invalid_attrs %{qtd: nil, description: nil, name: nil, price: nil, sku: nil, barcode: nil}

  def fixture(:product) do
    {:ok, product} = Product.create(%Product{}, @create_attrs)
    product
  end

  setup %{conn: conn} do
    Repo.delete_all(Product)
    Cache.flush()
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/1" do
    test "lists all products", %{conn: conn} do
      response = get(conn, Routes.product_path(conn, :index))
      assert response |> json_response(200)

      response |> json_response(200)
    end
  end

  describe "create product" do
    test "renders product when data is valid", %{conn: conn} do
      response = post(conn, Routes.product_path(conn, :create), product: @create_attrs)

      assert response |> json_response(201)

      expected_product = Product.get_by_sku(@create_attrs.sku)
      assert expected_product
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

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, Routes.product_path(conn, :update, id), product: @update_attrs)

      assert %{"id" => id} = json_response(conn, 200)["product"]

      assert Product.get(id) != nil
    end

    test "renders errors when data is invalid", %{conn: conn, product: %Product{id: id} = product} do
      conn = put(conn, Routes.product_path(conn, :update, id), product: @invalid_attrs)

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
      assert Product.get(product.id) == product
      conn = delete(conn, Routes.product_path(conn, :delete, product))

      response(conn, 204)

      assert is_nil(Product.get(product.id))
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

    test "renders error when data is invalid", %{conn: conn} do
      conn = get(conn, Routes.product_path(conn, :show, _id = "61e580fc6057a40203db022e"))
      response(conn, 404)
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    %{product: product}
  end
end
