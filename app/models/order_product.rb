# frozen_string_literal: true

#
# Represents a line item on the order
# Contains the quantity of the given product added to the order
#
class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product_version

  validates :quantity, presence: true

  def subtotal
    quantity * product_version.price_in_cents
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value order_id product_version_id quantity updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[order product_version]
  end
end
