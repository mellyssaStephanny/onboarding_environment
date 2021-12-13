defmodule ApiProductsWeb.ProductView do
  use ApiProductsWeb, :view
  alias ApiProductsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{id: product.id,
      name: product.name,
      sku: product.sku,
      description: product.description,
      amount: product.amount,
      price: product.price}
  end
end
