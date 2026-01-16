class Api::ProductsController < ApplicationController
  before_action :set_product, only: [:update, :destroy]
  
  def index
    page = (params[:page] || 1).to_i
    limit = [(params[:limit] || 10).to_i, 100].min
    sort = params[:sort] || "created_at"
    order = params[:order] || "desc"

    validate_pagination_params!(page, limit)
    validate_sort_params!(sort, order)

    offset = (page - 1) * limit
    total = Product.count
    products = Product.order("#{sort} #{order}").offset(offset).limit(limit)

    render json: {
      status: "success",
      data: products.map { |p| serialize_product(p) },
      meta: {
        total: total,
        page: page,
        limit: limit,
        totalPages: (total / limit.to_f).ceil
      }
    }, status: :ok
  end

  def create
    product = CreateProductService.new(product_params).call
    render json: { status: "success", data: serialize_product(product) }, status: :created
  rescue ArgumentError => e
    handle_argument_error(e)
  end

  def update
    authenticate_user!
    authorize_admin!
    
    product = UpdateProductService.new(@product, product_params).call
    render json: { status: "success", data: serialize_product(product) }, status: :ok
  rescue ArgumentError => e
    handle_argument_error(e)
  end

  def destroy
    authenticate_user!
    authorize_admin!
    
    @product.destroy
    render json: {
      status: "success",
      data: {
        id: @product.id,
        message: "Product deleted successfully"
      }
    }, status: :ok
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.permit(:title, :description, :quantity, :price)
  end

  def serialize_product(product)
    {
      id: product.id,
      title: product.title,
      description: product.description,
      quantity: product.quantity,
      price: product.price.to_f,
      createdAt: product.created_at.iso8601,
      updatedAt: product.updated_at.iso8601
    }
  end

  def validate_pagination_params!(page, limit)
    raise ArgumentError, "Invalid page or limit" if page < 1 || limit < 1
  end

  def validate_sort_params!(sort, order)
    valid_sorts = %w[name price created_at title]
    valid_orders = %w[asc desc]
    
    raise ArgumentError, "Invalid sort parameter" unless valid_sorts.include?(sort)
    raise ArgumentError, "Invalid order parameter" unless valid_orders.include?(order)
  end
end
