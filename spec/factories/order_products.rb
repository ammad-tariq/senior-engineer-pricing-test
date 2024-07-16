# frozen_string_literal: true

FactoryBot.define do
  factory :order_product do
    order
    product_version
    quantity { 1 }
  end
end
