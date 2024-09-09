class Item < ApplicationRecord
  belongs_to :store
  validates :name, presence: true, length: { minimum: 3}
  scope :filter_by_starts_with, -> (name) { where("name like ?", "#{name}%")}
  scope :filter_by_store_id, -> (store_id) { where(store_id: store_id) }

end
