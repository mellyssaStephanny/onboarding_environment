defmodule ApiProducts.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias ApiProducts.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field :sku, :string
    field :name, :string
    field :qtd, :integer
    field :price, :float
    field :barcode, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :qtd, :price, :barcode])
    |> validate_required([:sku, :name, :description, :qtd, :price, :barcode])
    |> validate_format(:sku, ~r/^([a-zA-Z0-9]|\-)+$/,
      message: "The SKU field must contain only alphanumerics and hyphen"
    )
    |> validate_number(:price, greater_than: 0)
    |> validate_length(:barcode, min: 8, max: 13)
  end

  def list, do: Repo.all(Product)

  def get(id) do
    Repo.one(from product in Product, where: product.id == ^id)
  end

  def get_by_sku(sku) do
    Repo.one(from product in Product, where: product.sku == ^sku)
  end

  def create(product, attrs \\ %{}) do
    product
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete(id), do: get(id) |> Repo.delete()

  def delete_all(), do: Repo.delete_all(Product)

  def change(product, attrs \\ %{}), do: Product.changeset(product, attrs)
end
