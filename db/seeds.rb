# frozen_string_literal: true

AdminUser.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
) if Rails.env.development?

sku = Sku.create!(product_code: 'SKU-001')

product = Product.create!(
  name: 'Product 1',
  price_in_cents: 1000,
  sku: sku
)
product.create_version

order = Order.create!(shipping_date: Date.today)

order_product = OrderProduct.create!(
  order: order,
  product_version: product.current_version,
  quantity: 2
)
