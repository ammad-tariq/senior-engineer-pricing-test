require 'rails_helper'

RSpec.describe OrderProduct do
  it 'has a valid factory' do
    expect(build(:order_product)).to be_valid
  end

  describe 'associations' do
    it 'belongs to order' do
      expect(described_class.new).to belong_to(:order)
    end

    it 'belongs to product_version' do
      expect(described_class.new).to belong_to(:product_version)
    end
  end

  describe 'validations' do
    it 'validates presence of quantity' do
      expect(described_class.new).to validate_presence_of(:quantity)
    end
  end

  describe 'subtotal' do
    let(:product_version) { build(:product_version, price_in_cents: 100) }
    let(:order_product) { build(:order_product, quantity: 2, product_version: product_version) }

    it 'returns the subtotal' do
      expect(order_product.subtotal).to eq(200)
    end
  end

  describe 'ransackable_attributes' do
    it 'returns an array with the attributes' do
      expect(described_class.ransackable_attributes).to eq(%w[created_at id id_value order_id product_version_id quantity updated_at])
    end
  end

  describe 'ransackable_associations' do
    it 'returns an array with associations' do
      expect(described_class.ransackable_associations).to eq(%w[order product_version])
    end
  end
end
