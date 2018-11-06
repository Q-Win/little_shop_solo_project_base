class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.references :item, foreign_key: true
      t.integer :rate
      t.integer :quantity
    end
  end
end
