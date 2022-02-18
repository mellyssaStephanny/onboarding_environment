defmodule ApiProducts.CatalogTest do
  use ApiProducts.DataCase, async: false

  alias ApiProducts.Catalog
  alias ApiProducts.Catalog.Product

  setup_all do
    %{
      valid_attrs: %{
        amount: 42,
        description: "some description",
        name: "some name",
        price: 120.5,
        sku: "some-sku",
        barcode: "123456789"
      },
      update_attrs: %{
        qtd: 43,
        description: "some updated description",
        name: "some updated name",
        price: 456.7,
        sku: "some-updated-sku",
        barcode: "123456789"
      },
      invalid_attrs: %{
        qtd: nil,
        description: nil,
        name: nil,
        price: nil,
        sku: nil,
        barcode: nil
      }
    }
  end

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Catalog.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Catalog.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Catalog.get_product(product.id) == product
    end

    test "get_product_by_sku/1 returns the product with given sky" do
      product = product_fixture()
      assert Catalog.get_product_by_sku(product.sku) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Catalog.create_product(@valid_attrs)
      assert product.qtd == 42
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.price == 120.5
      assert product.sku == "some-sku"
      assert product.barcode == "1234567890"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Catalog.update_product(product, @update_attrs)
      assert product.qtd == 43
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.price == 456.7
      assert product.sku == "some-updated-sku"
      assert product.barcode == "1234567890"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(product, @invalid_attrs)
      assert product == Catalog.get_product(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Catalog.delete_product(product)
      assert Catalog.get_product(product.id) == nil
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Catalog.change_product(product)
    end
  end
end
