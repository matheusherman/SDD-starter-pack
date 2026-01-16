class CreateProductService
  def initialize(params)
    @params = params
  end

  def call
    validate_input!
    create_product
  end

  private

  def validate_input!
    raise ArgumentError, "Title is required and must be between 1-100 characters" if invalid_title?
    raise ArgumentError, "Quantity is required" if @params[:quantity].blank?
    raise ArgumentError, "Price is required" if @params[:price].blank?
    raise ArgumentError, "Quantity must be a non-negative integer" if invalid_quantity?
    raise ArgumentError, "Price must be positive" if invalid_price?
    raise ArgumentError, "Description must not exceed 500 characters" if invalid_description?
  end

  def invalid_title?
    @params[:title].blank? || @params[:title].to_s.length > 100
  end

  def invalid_quantity?
    begin
      quantity = @params[:quantity].to_i
      quantity < 0
    rescue StandardError
      true
    end
  end

  def invalid_price?
    begin
      price = @params[:price].to_f
      price <= 0
    rescue StandardError
      true
    end
  end

  def invalid_description?
    @params[:description].present? && @params[:description].to_s.length > 500
  end

  def create_product
    product = Product.new(
      title: @params[:title],
      description: @params[:description],
      quantity: @params[:quantity],
      price: @params[:price]
    )

    raise ArgumentError, "Failed to create product" unless product.save

    product
  end
end
