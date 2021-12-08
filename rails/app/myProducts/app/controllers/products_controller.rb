class ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token

  def index
    products = Product.all
    render json: { products: products }
  end

  def show
    render json: @product
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
    if @product.destroy
      render json: {}, status: :no_content
    else
      render json: @product.errors, status: :not_found    
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :name, :description, :price, :qtd)
  end
end
