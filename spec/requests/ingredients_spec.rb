require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/ingredients", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Ingredient. As you add validations to Ingredient, be sure to
  # adjust the attributes here as well.
  # RSpec.describe 'Items Route', type: :request do
    path '/ingredients' do
      get 'Retrieves all ingredients for a store' do
        tags 'ingredients'
        produces 'application/json'
        parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', required: false
        
        response '200', 'ingredients found' do
          schema type: :array, items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string }
            }
          }
  
          let(:store) { create(:store) }
          let(:item) { create(:item, name: 'New Item', store: store) }
          before do
            create_list(:ingredient, 2, item: item)
          end
  
          run_test! do
            expect(json).not_to be_empty
            expect(json.size).to eq(2)
          end
        end
      end
  
      post 'Creates an ingredient for an item' do
        tags 'Ingredients'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :item_id, in: :path, type: :integer, description: 'ID of the store', required: true
        parameter name: :ingredient, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string }
          },
          required: ['name']
        }
  
        response '201', 'ingredient created' do
          let(:store) { create(:store) }
          let(:store_id) { store.id }
          let(:item) { create(:item, name: 'new item', store: store)}
          let(:item_id) {item.id}
          let(:ingredient) { { name: 'Lettuce', item_id: item_id } }
  
          run_test! do
            expect(json['name']).to eq('Lettuce')
          end
        end
  
        response '422', 'invalid request' do
          let(:store) { create(:store) }
          let(:store_id) { store.id }
          let(:item) { create(:item, name: 'new item', store: store)}
          let(:item_id) {item.id}
          
          let(:ingredient) { { name: '', item_id: item.id } }
  
          run_test! do
            expect(response.body).to include("is too short")
          end
        end
      end
    end
  
    path '/ingredients/{id}' do
      put 'Updates an ingredient' do
        tags 'Ingredients'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'ID of the item to update', required: true
        parameter name: :ingredient_params, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string, description: 'Name of the ingredient' }
          },
          required: ['name']
        }
  
        response '200', 'ingredient updated' do
          let!(:store) { create(:store) }
          let!(:item) { create(:item, name: 'Item1', store: store) }

          let!(:ingredient) { create(:ingredient, name: 'Old Ingredient', item_id: item_id) }
          let(:item_id) { item.id }
          let(:id) { ingredient.id }
          let(:ingredient_params) { { name: 'New Ingredient' } }
  
          run_test! do
            expect(json['name']).to eq('New Ingredient')
          end
        end
  
        # response '404', 'item or store not found' do
        #   let(:store_id) { 'invalid' }
        #   let(:id) { 'invalid' }
        #   let(:item_params) { { name: 'New Item', store_id: store_id } }
  
        #   run_test! do
        #     expect(response).to have_http_status(404)
        #   end
        # end
  
        response '422', 'invalid request' do
          let!(:store) { create(:store) }
          let!(:item) { create(:item, name: 'Item1', store: store) }

          let!(:ingredient) { create(:ingredient, name: 'Old Ingredient', item_id: item_id) }
          let(:item_id) { item.id }
          let(:id) { ingredient.id }
          let(:ingredient_params) { { name: '' } }
  
          run_test! do
            expect(response.body).to include("is too short")
          end
        end
      end
  
      delete 'Deletes an ingredient' do
        tags 'Ingredients'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'ID of the item to delete', required: true
        
        response '204', 'ingredient deleted' do
          let(:store) { create(:store) }
          let(:store_id) { store.id }
          let(:item) { create(:item, name: 'new item', store: store)}
          let(:item_id) {item.id}
          let(:ingredient) { create(:ingredient, name: 'Lettuce', item_id: item_id) }
          let(:id) { ingredient.id }
  
  
          run_test!
        end
  
        response '404', 'ingredient not found' do
          let(:store) { create(:store) }
          let(:store_id) { store.id }
          let(:item) { create(:item, name: 'new item', store: store)}
          let(:item_id) {item.id}
          let(:ingredient) { { name: 'Lettuce', item_id: item_id } }
          let(:id) { 'invalid' }
  
  
          
  
  
          run_test! do
            expect(response).to have_http_status(404)
          end
        end
      end
    end
    

 
end
