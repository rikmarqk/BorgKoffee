class CreateCoffeeReceipts < ActiveRecord::Migration[6.0]
  def change
    create_table :coffee_receipts do | t |
      t.integer :coffee_id
      t.integer :receipt_id
    end
  end
end
