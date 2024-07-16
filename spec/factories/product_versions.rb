FactoryBot.define do
  factory :product_version do
    product
    price_in_cents { 1000 }
  end
end
