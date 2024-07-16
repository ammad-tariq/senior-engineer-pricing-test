class PopulateProductVersions < ActiveRecord::Migration[7.1]
  def up
    Product.find_each do |product|
      version = ProductVersion.create!(
        product_id: product.id,
        price_in_cents: product.price_in_cents
      )
      product.update_column(:current_version_id, version.id)
    end
  end

  def down
    ProductVersion.delete_all
  end
end
