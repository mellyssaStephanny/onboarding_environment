defmodule ApiProducts.IndexProductTest do
  use ApiProductsWeb.ConnCase, async: false

  alias ApiProducts.IndexProduct

  @product %{
    qtd: 42,
    description: "some description",
    name: "some name",
    price: 120.5,
    sku: "some-sku",
    barcode: "123456789"
  }
  @update_product %{
    qtd: 43,
    description: "some updated description",
    name: "some updated name",
    price: 456.7,
    sku: "some-updated-sku",
    barcode: "987654321"
  }
  @invalid_id "61f1768ad157f704580d54f1"

  setup do
    IndexProduct.delete_product()
    :ok
  end

  describe "put product/1" do
    test "create new product" do
      assert IndexProduct.put_product(@product) == {:ok, 201}
    end
  end

  describe "get product/1" do
    test "get product if id invalid" do
      product = IndexProduct.put_product(@invalid_id)
      assert product == {:error, 422}
    end

    test "get product if id is valid" do
      IndexProduct.put_product(@product)
      product = IndexProduct.put_product(@product.id)
      assert product[:_id] == @product.id
    end
  end

  describe "search product/1" do
    test "search product" do
      IndexProduct.put_product(@product)
      assert IndexProduct.search_product(%{"id" => "61f1768ad157f704580d54f1"}) == {"id"}
    end
  end

  describe "update product/1" do
    test "update a product if id is valid" do
      IndexProduct.put_product(@update_product)
      product = IndexProduct.put_product(@update_product.id)

      assert product[:_id] == @product.id
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
