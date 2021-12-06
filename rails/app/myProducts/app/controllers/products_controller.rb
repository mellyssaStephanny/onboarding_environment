class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  # before_action :require_authorization!, only: [:show, :update, :destroy]

  def index
    products = Product.all
    render json: { products: products }
  end

  def show
    @product = Product.find_by(id: params[:id])
    render json: { product: @product }
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :price, :qtd)
  end
end
