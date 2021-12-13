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
    
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:sku, :name, :description, :qtd, :price])
    |> validate_required([:sku, :name, :description, :qtd, :price])
  end
end
