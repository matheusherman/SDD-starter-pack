# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
admin_user = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'Admin User'
  user.password = 'admin123456'
  user.password_confirmation = 'admin123456'
  user.role = 'admin'
end

puts "✅ Admin user created: admin@example.com / admin123456"

# Create some sample products
sample_products = [
  { title: 'Laptop Pro', description: 'High-performance laptop for professionals', quantity: 15, price: 1299.99 },
  { title: 'Wireless Mouse', description: 'Ergonomic wireless mouse with 5-year battery', quantity: 50, price: 29.99 },
  { title: 'USB-C Hub', description: '7-in-1 USB-C hub with HDMI, USB 3.0, and SD card reader', quantity: 30, price: 49.99 },
  { title: 'Mechanical Keyboard', description: 'RGB mechanical keyboard with cherry MX switches', quantity: 25, price: 149.99 },
  { title: 'Monitor 4K', description: '27 inch 4K UHD monitor with color accuracy', quantity: 10, price: 599.99 }
]

sample_products.each do |attrs|
  Product.find_or_create_by!(title: attrs[:title]) do |product|
    product.description = attrs[:description]
    product.quantity = attrs[:quantity]
    product.price = attrs[:price]
  end
end

puts "✅ Created #{Product.count} sample products"
