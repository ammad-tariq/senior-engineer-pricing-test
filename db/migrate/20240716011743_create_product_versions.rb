class CreateProductVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :product_versions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :price_in_cents, null: false
      t.timestamps
    end

    add_reference :products, :current_version, foreign_key: { to_table: :product_versions }
    add_reference :order_products, :product_version, foreign_key: true
    remove_reference :order_products, :product
  end
end
