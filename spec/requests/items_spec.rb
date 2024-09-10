require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Items API', type: :request do

  path '/items' do
    get 'Retrieves all items for a store' do
      tags 'Items'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', required: false
      
      response '200', 'items found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string }
          }
        }

        let(:store) { create(:store) }
        before do
          create_list(:item, 2, store: store)
        end
        let(:store_id) { store.id }

        run_test! do
          expect(json).not_to be_empty
          expect(json.size).to eq(2)
        end
      end
    end

    post 'Creates an item for a store' do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :store_id, in: :path, type: :integer, description: 'ID of the store', required: true
      parameter name: :item, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '201', 'item created' do
        let(:store) { create(:store) }
        let(:store_id) { store.id }
        let(:item) { { name: 'Item 1', store_id: store_id } }

        run_test! do
          expect(json['name']).to eq('Item 1')
        end
      end

      response '422', 'invalid request' do
        let(:store) { create(:store) }
        let(:store_id) { store.id }
        let(:item) { { name: '' } }

        run_test! do
          expect(response.body).to include("is too short")
        end
      end
    end
  end

  path '/items/{id}' do
    put 'Updates an item' do
      tags 'Items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the item to update', required: true
      parameter name: :item_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, description: 'Name of the item' }
        },
        required: ['name']
      }

      response '200', 'item updated' do
        let!(:store) { create(:store) }
        let!(:item) { create(:item, name: 'Old Item', store_id: store_id) }
        let(:store_id) { store.id }
        let(:id) { item.id }
        let(:item_params) { { name: 'New Item' } }

        run_test! do
          expect(json['name']).to eq('New Item')
        end
      end

      response '404', 'item or store not found' do
        let(:store_id) { 'invalid' }
        let(:id) { 'invalid' }
        let(:item_params) { { name: 'New Item', store_id: store_id } }

        run_test! do
          expect(response).to have_http_status(404)
        end
      end

      response '422', 'invalid request' do
        let!(:store) { create(:store) }
        let!(:item) { create(:item, store: store) }
        let(:store_id) { store.id }
        let(:id) { item.id }
        let!(:item_params) { { name: '' } }

        run_test! do
          expect(response.body).to include("is too short")
        end
      end
    end

    delete 'Deletes an item' do
      tags 'Items'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the item to delete', required: true
      
      response '204', 'item deleted' do
        let!(:store) { create(:store) }
        let!(:item) { create(:item, store: store) }
        let(:store_id) { store.id }
        let(:id) { item.id }
        


        run_test!
      end

      response '404', 'item not found' do
        let!(:store) { create(:store) }
        let!(:item) { create(:item, store: store) }
        let(:id) {'invalid'}


        


        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end