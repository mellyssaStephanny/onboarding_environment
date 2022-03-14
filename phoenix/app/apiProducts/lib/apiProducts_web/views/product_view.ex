defmodule ApiProductsWeb.ProductView do
  use ApiProductsWeb, :view
  alias ApiProductsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{products: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{product: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      sku: product.sku,
      description: product.description,
      qtd: product.qtd,
      barcode: product.barcode,
      price: product.price
    }
  end
end
