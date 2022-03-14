defmodule ApiProducts.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias ApiProducts.Repo
  alias __MODULE__

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "products" do
    field(:sku, :string)
    field(:name, :string)
    field(:qtd, :integer)
    field(:price, :float)
    field(:barcode, :string)
    field(:description, :string)

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

  def list do
    list =
      Product
      |> Repo.all()
      |> Enum.map(fn product -> product_body(product) end)
  end

  def product_body(product) do
    %{
      "id" => product.id,
      "sku" => product.sku,
      "qtd" => product.qtd,
      "name" => product.name,
      "price" => product.price,
      "barcode" => product.barcode,
      "description" => product.description
    }
  end

  def get(id) do
    Repo.one(from(product in Product, where: product.id == ^id))
  end

  def get_by_sku(sku) do
    Repo.one(from(product in Product, where: product.sku == ^sku))
  end

  def create(product, attrs \\ %{}) do
    product
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(nil, attrs), do: {:error, :not_found}

  def update(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_by_sku(sku) do
    product = get_by_sku(sku)
    delete(product)
  end

  def delete(nil), do: {:error, :not_found}

  def delete(product) do
    case Repo.delete(product) do
      nil ->
        {:error, :not_found}

      _ ->
        {:ok, "no content"}
    end
  end

  def delete_all(), do: Repo.delete_all(Product)

  def change(product, attrs \\ %{}), do: Product.changeset(product, attrs)
end
