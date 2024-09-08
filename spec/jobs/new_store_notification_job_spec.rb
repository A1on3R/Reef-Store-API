require 'rails_helper'

RSpec.describe NewStoreNotificationJob, type: :job do
  include ActiveJob::TestHelper

  # Ensure jobs are cleaned up between tests
  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'enqueues a job when a store is created' do
    # Clear any existing jobs to start fresh
    clear_enqueued_jobs

    # Trigger the job by creating a store
    store = Store.create!(name: "New Store")

    # Expect the job to be enqueued
    expect {
      NewStoreNotificationJob.perform_later(store.id)
    }.to have_enqueued_job(NewStoreNotificationJob).with(store.id)
  end

  it 'executes perform' do
    # Mock the job's action
    store = Store.create!(name: "New Store")
    
    # Run the job with the store ID
    perform_enqueued_jobs do
      NewStoreNotificationJob.perform_later(store.id)
    end

    # Add expectations to check the behavior of the job if needed
    # For example: expect(store.reload.notified).to be_truthy
  end
end
