defmodule ApiProducts.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias ApiProducts.Repo
  alias ApiProducts.Catalog.Product

  @doc """
  Returns the list of products.
  """

  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.
  """
  def get_product(id) do
    Repo.one(from p in Product, where: p.id == ^id)
  end

  def get_product_by_sku(sku) do
    Repo.one(from p in Product, where: p.sku == ^sku)
  end

  @doc """
  Creates a product.
  """

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.
  """

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.
  """

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def delete_all() do
    Repo.delete_all(Product)
  end

  @doc """
  Change product.
  """

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
