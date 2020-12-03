class Receipt < ActiveRecord::Base
    belongs_to :user
    has_many :coffee_receipts
    has_many :coffees, through: :coffee_receipts
end