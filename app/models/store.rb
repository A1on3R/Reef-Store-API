class Store < ApplicationRecord
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3}

  
  def enque_new_store_notification_job
    NewStoreNotificationJob.perform_later(id)
  end

end
