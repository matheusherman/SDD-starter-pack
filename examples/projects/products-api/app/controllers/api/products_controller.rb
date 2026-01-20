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
    total_pages = (total / limit.to_f).ceil

    render json: {
      status: "success",
      data: products.map { |p| ProductSerializer.new(p).serialize },
      meta: {
        total: total,
        page: page,
        limit: limit,
        totalPages: total_pages
      }
    }, status: :ok
  end

  def show
    # Validate UUID format
    unless params[:id].match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i)
      return render json: {
        status: "error",
        error: {
          code: "INVALID_PRODUCT_ID",
          message: "ID do produto inválido"
        }
      }, status: :bad_request
    end

    begin
      product = Product.find(params[:id])
      render json: { status: "success", data: ProductSerializer.new(product).serialize }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: {
        status: "error",
        error: {
          code: "PRODUCT_NOT_FOUND",
          message: "Produto não encontrado"
        }
      }, status: :not_found
    rescue StandardError => e
      render json: {
        status: "error",
        error: {
          code: "INVALID_PRODUCT_ID",
          message: "ID do produto inválido"
        }
      }, status: :bad_request
    end
  end

  def create
    product = CreateProductService.new(product_params).call
    render json: { status: "success", data: ProductSerializer.new(product).serialize }, status: :created
  rescue ArgumentError => e
    handle_argument_error(e)
  end

  def update
    authenticate_user!
    authorize_admin!
    
    product = UpdateProductService.new(@product, product_params).call
    render json: { status: "success", data: ProductSerializer.new(product).serialize }, status: :ok
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
