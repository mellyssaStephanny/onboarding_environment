defmodule ApiProducts.IndexProductTest do
  use ApiProductsWeb.ConnCase, async: false

  alias ApiProducts.IndexProduct
  import Mock

  @product %{
    id: "5e9618293ab04b0046343fe8",
    qtd: 42,
    description: "some description",
    name: "some name",
    price: 120.5,
    sku: "some-sku",
    barcode: "123456789"
  }
  @product_response %{
    _id: "5e9618293ab04b0046343fe8",
    _index: "api-products",
    _shards: %{failed: 0, successful: 1, total: 2},
    _type: "products",
    _version: 19,
    created: false
  }
  @invalid_id "61f1768ad157f704580d54f1"
  @valid_url "/api-products/products/5e9618293ab04b0046343fe8"

  setup do
    # IndexProduct.delete_product()
    :ok
  end

  setup_with_mocks [
    {Tirexs.HTTP, [],
     put: fn
       @valid_url, _json -> {:ok, 200, @product_response}
       _invalid_url, _json -> {:error, 422}
     end,
     delete: fn
       @valid_url -> {:ok, 204}
       _invalid_url -> {:error, 422}
     end,
     get: fn
       _valid_url -> {:ok, 200, %{hits: %{hits: []}}}
     end}
  ] do
    :ok
  end

  describe "put product/1" do
    test "put product if id invalid" do
      product = IndexProduct.put_product(@product)
      assert product == {:error, 422}
      assert_called(Tirexs.HTTP.put(:_, :_))
    end

    test "put product if id is valid" do
      product = IndexProduct.put_product(@product)
      assert product
      assert_called(Tirexs.HTTP.put(:_, :_))
    end
  end

  describe "search product/1" do
    test "search product" do
      assert IndexProduct.search_product(@product)
      assert_called(Tirexs.HTTP.get(:_))
    end
  end

  describe "update product/1" do
    test "update a product if id is valid" do
      product = IndexProduct.put_product(@product)
      assert product
      assert_called(Tirexs.HTTP.put(:_, :_))
    end
  end

  describe "delete product/1" do
    test "delete product if id is valid" do
      IndexProduct.put_product(@product)
      assert IndexProduct.delete_product(@product.id) == {:ok, 204}
    end

    test "delete product id is invalid" do
      assert IndexProduct.delete_product(@invalid_id) == {:error, 422}
    end
  end
end
