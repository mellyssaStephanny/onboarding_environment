defmodule ApiProducts.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  
  schema "products" do
    field :sku,         :string
    field :name,        :string
    field :description, :string
    field :qtd,         :integer  
    field :price,       :float
    field :barcode      :integer
    
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :qtd, :price, :barcode])
    |> validate_required([:sku, :name, :description, :qtd, :price, :barcode])
    |> validate_format(:sku, ~r/^([a-zA-Z0-9]|\-)+$/, message: "The SKU field must contain only alphanumerics and hyphen")
    |> validate_number(:price, greater_than: 0)
    |> validate_length(:barcode, max: 13)
  end
end
