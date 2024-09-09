# require 'rails_helper'

# # This spec was generated by rspec-rails when you ran the scaffold generator.
# # It demonstrates how one might use RSpec to test the controller code that
# # was generated by Rails when you ran the scaffold generator.
# #
# # It assumes that the implementation code is generated by the rails scaffold
# # generator. If you are using any extension libraries to generate different
# # controller code, this generated spec may or may not pass.
# #
# # It only uses APIs available in rails and/or rspec-rails. There are a number
# # of tools you can use to make these specs even more expressive, but we're
# # sticking to rails and rspec-rails APIs to keep things simple and stable.

# RSpec.describe "/items", type: :request do
#   # This should return the minimal set of attributes required to create a valid
#   # Item. As you add validations to Item, be sure to
#   # adjust the attributes here as well
#   let(:store) {Store.create(name: "ABC")}

#   let(:valid_attributes) {
#     # FactoryBot.attributes_for(:item)
#     {:name=>"MyString", :price=>1.5, :description=>"MyString", :store_id=>store.id}
#   }

#   let(:invalid_attributes) {
#     { :name => nil, :price => 1.5, :description => "MyString", :store_id => store.id }
#   }

#   # This should return the minimal set of values that should be in the headers
#   # in order to pass any filters (e.g. authentication) defined in
#   # ItemsController, or in your router and rack
#   # middleware. Be sure to keep this updated too.
#   let(:valid_headers) {
#     {}
#   }

#   describe "GET /index" do
#     it "renders a successful response" do
#       Item.create! valid_attributes
#       get items_url, headers: valid_headers, as: :json
#       expect(response).to be_successful
#     end
#   end

#   describe "GET /show" do
#     it "renders a successful response" do
#       item = Item.create! valid_attributes
#       get item_url(item), as: :json
#       expect(response).to be_successful
#     end
#   end

#   describe "POST /create" do
#     context "with valid parameters" do
#       it "creates a new Item" do
#         expect {
#           post items_url,
#                params: { item: valid_attributes }, headers: valid_headers, as: :json
#         }.to change(Item, :count).by(1)
#       end

#       it "renders a JSON response with the new item" do
#         post items_url,
#              params: { item: valid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:created)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end

#     context "with invalid parameters" do
#       it "does not create a new Item" do
#         expect {
#           post items_url,
#                params: { item: invalid_attributes }, as: :json
#         }.to change(Item, :count).by(0)
#       end

#       it "renders a JSON response with errors for the new item" do
#         post items_url,
#              params: { item: invalid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end
#   end

#   describe "PATCH /update" do
#     context "with valid parameters" do
#       let(:new_attributes) {
#         {:name=>"NewName", :price=>1.5, :description=>"MyString", :store_id=>store.id}

#       }

#       it "updates the requested item" do
#         item = Item.create! valid_attributes
#         patch item_url(item),
#               params: { item: new_attributes }, headers: valid_headers, as: :json
#         item.reload
#         expect(item.name).to eq new_attributes[:name]
#       end

#       it "renders a JSON response with the item" do
#         item = Item.create! valid_attributes
#         patch item_url(item),
#               params: { item: new_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:ok)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end

#     context "with invalid parameters" do
#       it "renders a JSON response with errors for the item" do
#         item = Item.create! valid_attributes
#         patch item_url(item),
#               params: { item: invalid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end
#   end

#   describe "DELETE /destroy" do
#     it "destroys the requested item" do
#       item = Item.create! valid_attributes
#       expect {
#         delete item_url(item), headers: valid_headers, as: :json
#       }.to change(Item, :count).by(-1)
#     end
#   end
# end
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

      # response '404', 'store not found' do
      #   let(:id) { 'invalid' }

      #   run_test! do
      #     expect(response).to have_http_status(404)
      #   end
      # end
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