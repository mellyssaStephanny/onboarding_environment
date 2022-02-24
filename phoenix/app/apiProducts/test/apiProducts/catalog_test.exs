defmodule ApiProducts.CatalogTest do
  use ApiProducts.DataCase, async: false

  alias ApiProducts.Catalog

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
      |> Product.create()

    product
  end

  test "list_products/0 returns all products" do
    product = product_fixture()
    assert Product.list() == [product]
  end

  test "get_product/1 returns the product with given id" do
    product = product_fixture()
    assert Product.get(product.id) == product
  end

  test "get_product_by_sku/1 returns the product with given sky" do
    product = product_fixture()
    assert Product.get_by_sku(product.sku) == product
  end

  test "create_product/1 with valid data creates a product" do
    assert {:ok, Product = product} = Product.create(@valid_attrs)
    assert product.qtd == 42
    assert product.description == "some description"
    assert product.name == "some name"
    assert product.price == 120.5
    assert product.sku == "some-sku"
    assert product.barcode == "1234567890"
  end

  test "create_product/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Product.create(@invalid_attrs)
  end

  test "update_product/2 with valid data updates the product" do
    product = product_fixture()
    assert {:ok, %Product{} = product} = Product.update(product, @update_attrs)
    assert product.qtd == 43
    assert product.description == "some updated description"
    assert product.name == "some updated name"
    assert product.price == 456.7
    assert product.sku == "some-updated-sku"
    assert product.barcode == "1234567890"
  end

  test "update_product/2 with invalid data returns error changeset" do
    product = product_fixture()
    assert {:error, %Ecto.Changeset{}} = Product.update(product, @invalid_attrs)
    assert product == Product.get(product.id)
  end

  test "delete_product/1 deletes the product" do
    product = product_fixture()
    assert {:ok, %Product{}} = Product.delete(product)
    assert Product.get(product.id) == nil
  end

  test "change_product/1 returns a product changeset" do
    product = product_fixture()
    assert %Ecto.Changeset{} = Product.change(product)
  end
end
