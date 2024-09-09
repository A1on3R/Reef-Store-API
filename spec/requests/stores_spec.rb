require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Stores API', type: :request do

  path '/stores' do

    get 'Retrieves all stores' do
      tags 'Stores'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', required: false
      parameter name: :starts_with, in: :query, type: :string, description: 'Search Query to search by name', required: false
      
      
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
    put 'Updates a store' do
      tags 'Stores'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the store to update', required: true
      parameter name: :store_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Name of the store' },
          description: { type: :string, description: 'Description of the store' }
        },
        required: ['name']
      }
  
      response '200', 'store updated' do
        let!(:store) { create(:store, name: 'Old Name') }
        let(:id) { store.id }
        let(:store_params) { { name: 'New Name' } }
  
        run_test! do
          expect(json['name']).to eq('New Name')
        end
      end
  
      response '404', 'store not found' do
        let(:id) { 'invalid' }
        let(:store_params) { { name: 'New Name' } }
  
        run_test! do
          expect(response).to have_http_status(404)
        end
      end
  
      response '422', 'invalid request' do
        let!(:store) { create(:store) }
        let(:id) { store.id }
        let!(:store_params) { { name: '' } }
  
        run_test! do
          expect(response.body).to include("is too short")
        end
      end
    end
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
