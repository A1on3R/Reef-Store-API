# Stores API

This API allows you to manage stores, items, and ingredients, providing full CRUD (Create, Read, Update, Delete) functionality.

## Overview of Solution
 We were able to include implementations of
 - Rails API that manages stores, items, and ingredients
 - All CRUD functionality for the 3 basic models
 - Pagination and filtering
 - Rspec tests that work with Swagger to generate documentation
 - Set up for background job to be created upon creating a store
 - Route for number of items in a store

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Endpoints](#endpoints)
- [Code](#code)
  - [Stores](#stores)
  - [Items](#items)
  - [Ingredients](#ingredients)

## Installation (Using Linux with WSL)
1. Clone the repository:
   ```bash
   git clone https://github.com/A1on3R/Reef-Store-API.git
   
2. Install dependencies:
   ```bash
   bundle install

3. You should run the spec to make sure the api is functioning
   ```bash
   bundle exec rspec
   
4. Setup the database(Or you can skip this and just start creating stores):
   ```bash
   rails db:create db:migrate db:seed
   
5. Start the server:
   ```bash
   rails server
   
You may have to start your postgres service and create a user named postgres with password postgres (included in the database.yml file)
```bash
sudo service postgresql start
sudo -u postgres psql
```
Then create the user to match the names in my `database.yml` file
```bash
=# create user postgres with password 'postgres';

```
Or you may Alter the `database.yml` file to properly access your postgres

## Usage
Swagger is included so that you can run the app and access at `http://localhost:3000/api-docs`

Also, After setting up, you can interact with the API using tools like `Postman` or `curl`.

## Endpoints

### Stores
You can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)

- **GET** `/stores` – List all stores
- **GET** `/stores/:id` – Get a specific store
- **GET** `/stores/:id/item_count` – Get a specific store with `item_count` in the response
- **POST** `/stores` – Create a new store
- **PUT** `/stores/:id` – Update a store
- **DELETE** `/stores/:id` – Delete a store

### Items
You can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)

You can also filter by store by using `&store_id=` to find items by a certain store
- **GET** `/items` – List all items
- **GET** `/items/:id` – Get a specific item
- **POST** `/items` – Create a new item (Existing store ID required)
- **PUT** `items/:id` – Update an item
- **DELETE** `/items/:id` – Delete an item

### Ingredients
- **GET** `/ingredients` – List all ingredients
- **GET** `/ingredients/:id` – Get a specific ingredient
- **POST** `/ingredients` – Create a new ingredient (Existing item required)
- **PUT** `/ingredients/:id` – Update an ingredient
- **DELETE** `/ingredients/:id` – Delete an ingredient

## Code
Controller example with pagination and filtering. See the controllers directory in the app
```
class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]
  ITEMS_PER_PAGE = 5

  # GET /items
  # GET /items.json
  def index
    # Start by getting all the items
    @items = Item.all
    @items = Item.filter_by_store_id(params[:store_id]) if params[:store_id].present?
  
    # Apply filtering if the filter parameter is present
    @items = @items.filter_by_starts_with(params[:starts_with]) if params[:starts_with].present? 
  
    # Now apply pagination to the filtered results
    @page = params.fetch(:page, 0).to_i
    @items = @items.offset(@page * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    
    render json: @items
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    if @item.save
      render :show, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      render :show, status: :ok, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :description, :store_id)
    end
end
```
And example of a spec file which tests basic crud functionality and also generates documentation for using swagger
```
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
```
In `stores_controller.rb` we see how we create the background job when the store is created:
```
def create
    @store = Store.new(store_params)

    if @store.save
      NewStoreNotificationJob.perform_later(@store.id)
      render json: @store, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end
```
then we define the job in `new_store_notification_job.rb`

Also see
- swagger.yaml which is generated by running `rswag:install:swaggerize` when specs are written and passing
- model files to see there isn't much but the validations and scopes used for filtering

RESTful API is Open for modification or enhancement if requirements are changed. 
