class CoffeeReceipt < ActiveRecord::Base
    belongs_to :coffee
    belongs_to :receipt
end