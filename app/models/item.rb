class Item < ApplicationRecord
  belongs_to :store
  validates :name, presence: true, length: { minimum: 3}

end
