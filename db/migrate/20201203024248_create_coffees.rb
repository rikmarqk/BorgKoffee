class CreateCoffees < ActiveRecord::Migration[6.0]
  def change
    create_table :coffees do | t |
      t.string :name
      t.string :category
      t.string :season
      t.float :price
    end
  end
end
