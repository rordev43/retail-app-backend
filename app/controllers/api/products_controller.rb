# app/controllers/api/products_controller.rb
class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy, :approve, :reject]
  
  def index
    @products = Product.where(status: 'active').order(created_at: :desc)
    render json: @products
  end
 
  # I would preferrably want to handle search using the same
  # active listing above endpoint and in that case we can move
  # this search logic to model and handle by calling the scope
  # in above endpoint, but as per requirement docx, I am stick 
  # to implement as per the instructions.

  # ALSO: we can use GIN-Indexes for product name and other string
  # searching columns, but for now I am focused to try to be simple
  # and to the point to complete this challenge.
  def search
    @products = Product.where(nil)
    @products = @products.where('name LIKE ?', "%#{params[:productName]}%") if params[:productName].present?
    @products = @products.where(price: params[:minPrice]..params[:maxPrice]) if params[:minPrice].present? && params[:maxPrice].present?
    @products = @products.where('created_at >= ?', params[:minPostedDate].to_date) if params[:minPostedDate].present?
    @products = @products.where('created_at <= ?', params[:maxPostedDate].to_date) if params[:maxPostedDate].present?
    render json: @products
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
    if @product.price > (@product.price * 0.5)
      @product.status = 'pending_approval'
    end
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.status = 'pending_approval'
    @product.destroy
  end
  
  def approval_queue
    @approval_queue = ApprovalQueue.order(created_at: :asc).map(&:product)
    render json: @approval_queue
  end

  def approve
    if @product.present?
      @product.update(status: 'active')
      @product.approval_queue.destroy
      head :no_content
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end

  def reject
    if @product.present?
      @product.approval_queue.destroy
      head :no_content
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end
  
  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :status)
  end
end
