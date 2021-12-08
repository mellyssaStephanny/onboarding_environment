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

  def as_json(*a)
    hash = super()
    hash['id'] = hash.delete('_id').to_s
    hash.as_json(only: %w[id sku name description qtd price])
  end
end
