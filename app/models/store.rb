class Store < ApplicationRecord
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3}

end
