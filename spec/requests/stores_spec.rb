# require 'rails_helper'


# RSpec.describe "Stores", type: :request do


# let!(:store_id) { @stores.first.id }
# before(:all) do
#   @stores = create_list(:store,2)
#   get '/stores'
# end


#   describe "GET /stores" do
    
   
#    it 'returns stores' do
#     get '/stores'
#     expect(json).not_to be_empty
#     expect(json.size).to eq(2)
#    end
#    it 'returns status code 200' do
#      expect(response).to have_http_status(200)
#    end
    
#   end

#   describe 'POST /stores' do
#     # valid payload
#     let(:valid_name) { { name: 'XYZ' } }
#     before do
#       # Clear any previously enqueued jobs
#       clear_enqueued_jobs
#       clear_performed_jobs
  
#       # Make the POST request
#       post '/stores', params: { store: valid_name }
#     end
#     context 'when the request is valid' do
#       # before { post '/stores', params:{'store': valid_name } }
#       it 'creates a store' do
#         expect(json['name']).to eq('XYZ')
#       end
#       it 'returns status code 201' do
#         expect(response).to have_http_status(201)
#       end
#       it 'enqueues NewStoreNotificationJob' do
#         expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 1
#       end
#     end
#     context 'when the request is invalid' do
#       before { post '/stores', params: {'store': { name: ''} } }
#       it 'returns status code 422' do
#         expect(response).to have_http_status(422)
#       end
#       it 'returns a validation failure message' do
#         expect(response.body)
#        .to include("is too short")
#       end
#     end
#   end


#   # Test suite for DELETE /category/:id
#  describe 'DELETE /stores/:id' do
#     before { delete "/stores/#{store_id}" }
#     it 'returns status code 204' do
#       expect(response).to have_http_status(204)
#     end
#   end
# end
require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Stores API', type: :request do

  path '/stores' do

    get 'Retrieves all stores' do
      tags 'Stores'
      produces 'application/json'
      # parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', required: false

      
      response '200', 'stores found' do
        schema type: :array, items: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string }
        }
      }
      before do
        # Create stores before the request
        create_list(:store, 2)
      end

        run_test! do
          expect(json).not_to be_empty
          expect(json.size).to eq(2)
        end
      end
    end

    post 'Creates a store' do
      tags 'Stores'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :store, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'store created' do
        let(:store) { { name: 'XYZ' } }

        run_test! do

          expect(json['name']).to eq('XYZ')
        end
      end

      response '422', 'invalid request' do
        let(:store) { { name: '' } }

        run_test! do
          expect(response.body).to include("is too short")
        end
      end
    end
  end

  path '/stores/{id}' do
    delete 'Deletes a store' do
      tags 'Stores'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'store deleted' do
        let!(:store) { create(:store) }
        let(:id) { store.id }

        run_test!
      end

      response '404', 'store not found' do
        let(:id) { 'invalid' }

        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end
