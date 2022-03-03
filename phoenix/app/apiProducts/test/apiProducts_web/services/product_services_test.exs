defmodule ApiProductsWeb.ProductServicesTest do
  use ApiProducts.DataCase

  import Mock

  alias ApiProductsWeb.Services.Product
  alias ApiProducts.IndexProduct
  alias ApiProducts.Catalog

  setup_all do
    %{
      create_attrs: %{
        id: "12a345abc678a123456a1234",
        qtd: 42,
        description: "some description",
        name: "some name",
        price: 120.5,
        sku: "some-sku",
        barcode: "123456789"
      },
      invalid_attrs: %{
        qtd: 10,
        description: "description test",
        name: "",
        price: 0,
        sku: "invalid-sku",
        barcode: "12345"
      },
      updated_attrs: %{
        id: "61f161dbd448f703274c5d39",
        qtd: 19,
        description: "updated description",
        name: "updated name",
        price: 157.9,
        sku: "sku-updated",
        barcode: "0010020030"
      }
    }
  end

  describe "fetch_all/1" do
    test "lists all products by elasticsearch" do
      with_mock(Tirexs.HTTP, get: fn _index -> {:ok, 200} end) do
        assert_called(Tirexs.HTTP.get("api-products/products/_search"))
      end
    end

    test "lists all products by database", %{product: product} do
      with_mock(Catalog, list_product: fn _get_product -> {:ok, 201} end) do
        assert_called(Product.list(product))
      end
    end
  end

  describe "create/1" do
    test "create product with valid params", %{create_attrs: create_attrs} do
      with_mock(IndexProduct, put_product: fn _produxt_params -> {:ok, 201} end) do
        {:ok, create_attrs} = Product.create(create_attrs)
        assert called(IndexProduct.put_product(create_attrs))
      end
    end
  end

  describe "update/2" do
    test "update with product invalid id" do
    end

    test "update product with valid id", %{updated_attrs: updated_attrs, product: product} do
      with_mock(IndexProduct, put_product: fn _produxt_params -> {:ok, 201} end) do
        {:ok, result} = Product.update(product, updated_attrs)

        assert called(IndexProduct.put_product(result))
      end
    end
  end

  describe "delete/1" do
    test "delete product with invalid id" do
      assert Product.delete(nil) == {:error, :not_found}
    end

    test "delete product", %{product: product} do
      with_mock(IndexProduct, delete_product: fn _delete -> {:ok, 201} end) do
        Product.delete(product)

        assert_called(IndexProduct.delete_product(product))
      end
    end
  end
end
