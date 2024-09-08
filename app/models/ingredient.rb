class Ingredient < ApplicationRecord
  belongs_to :item
  validates :name, presence: true, length: { minimum: 3}

end
