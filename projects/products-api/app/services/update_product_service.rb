class UpdateProductService
  def initialize(product, params)
    @product = product
    @params = params
  end

  def call
    validate_input!
    update_product
  end

  private

  def validate_input!
    if @params[:title].present?
      raise ArgumentError, "Title must be between 1-100 characters" if @params[:title].to_s.length > 100
    end
    
    if @params[:quantity].present?
      quantity = @params[:quantity].to_i
      raise ArgumentError, "Quantity must be non-negative" if quantity < 0
    end

    if @params[:price].present?
      price = @params[:price].to_f
      raise ArgumentError, "Price must be positive" if price <= 0
    end

    if @params[:description].present?
      raise ArgumentError, "Description must not exceed 500 characters" if @params[:description].to_s.length > 500
    end
  end

  def update_product
    @product.update!(
      title: @params[:title] || @product.title,
      description: @params[:description] || @product.description,
      quantity: @params[:quantity] || @product.quantity,
      price: @params[:price] || @product.price
    )
    
    @product
  end
end
