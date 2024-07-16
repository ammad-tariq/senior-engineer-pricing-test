# frozen_string_literal: true

#
# Represents a single order
#
class Order < ApplicationRecord
  has_many :order_products, dependent: :destroy
  accepts_nested_attributes_for :order_products, allow_destroy: true

  validates :shipping_date, presence: true

  def total
    order_products.sum(&:subtotal)
  end

  def add_product(product, quantity)
    product_version = product.current_version
    order_products.create!(product_version: product_version, quantity: quantity)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value shipping_date updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['order_products']
  end
end
