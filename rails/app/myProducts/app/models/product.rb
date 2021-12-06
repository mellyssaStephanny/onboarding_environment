class Product
  include Mongoid::Document

  field :sku, type: String
  field :name, type: String
  field :description, type: String
  field :qtd, type: Integer
  field :price, type: Float

  validates :sku, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :qtd, presence: true
  validates :price, presence: true
end
