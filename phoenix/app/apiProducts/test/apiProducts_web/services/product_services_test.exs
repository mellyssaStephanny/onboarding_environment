defmodule ApiProductsWeb.ProductServicesTest
  use ApiProducts.DataCase

  import Mock

  alias ApiProductsWeb.Services.Product

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
      }
    }
  end

  describe "list/1" do
    test "lists all products", %{conn: conn} do
    end
  end

  describe "get/1" do
  end

  describe "create/1" do
  end

  describe "update/1" do
  end

  describe "delete/1" do
  end
end
