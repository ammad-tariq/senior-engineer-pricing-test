# frozen_string_literal: true

#
# Represents a single product
#
class Product < ApplicationRecord
  belongs_to :sku
  has_many :product_versions, dependent: :destroy
  belongs_to :current_version, class_name: 'ProductVersion', optional: true

  after_save :create_version, if: :saved_change_to_price_in_cents?

  validates :name, presence: true
  validates :price_in_cents, presence: true

  def create_version
    version = product_versions.create!(
      price_in_cents: price_in_cents
    )
    update_column(:current_version_id, version.id)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id id_value name price_in_cents sku_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['sku']
  end
end
