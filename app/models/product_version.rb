class ProductVersion < ApplicationRecord
  belongs_to :product

  validates :price_in_cents, presence: true
end
