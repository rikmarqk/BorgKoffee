class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do | t |
      t.string :name
      t.integer :date_of_birth
      t.string :email
      t.integer :receipt_id
    end
  end
end
