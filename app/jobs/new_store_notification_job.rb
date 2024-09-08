class NewStoreNotificationJob < ApplicationJob
  queue_as :default

  def perform(id)
    # Do something later
    puts "hi"
  end
end
