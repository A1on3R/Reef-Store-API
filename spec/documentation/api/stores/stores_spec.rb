require 'swagger_helper'

RSpec.describe 'api/stores/controller', type: :request do
    # path '/stores' do

    #     post 'Creates a store' do
    #       tags 'Stores'
    #       consumes 'application/json'
    #       parameter name: :store, in: :body, schema: {
    #         type: :object,
    #         properties: {
    #           name: { type: :string },
    #           description: { type: :string }
    #         },
    #         required: [ 'name' ]
    #       }
    
    #       response '201', 'store created' do
    #         let(:store) { { store: { name: 'foo', description: 'bar' } } }
    #         run_test!
    #       end
    
    #       response '422', 'invalid request' do
    #         let(:store) { { name: '' } }
    #         run_test!
    #       end
    #     end
    #   end
    
    #   path '/blogs/{id}' do
    
    #     get 'Retrieves a blog' do
    #       tags 'Blogs', 'Another Tag'
    #       produces 'application/json', 'application/xml'
    #       parameter name: :id, in: :path, type: :string
    #       request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'
    
    #       response '200', 'blog found' do
    #         schema type: :object,
    #           properties: {
    #             id: { type: :integer },
    #             title: { type: :string },
    #             content: { type: :string }
    #           },
    #           required: [ 'id', 'title', 'content' ]
    
    #         let(:id) { Blog.create(title: 'foo', content: 'bar').id }
    #         run_test!
    #       end
    
    #       response '404', 'blog not found' do
    #         let(:id) { 'invalid' }
    #         run_test!
    #       end
    
    #       response '406', 'unsupported accept header' do
    #         let(:'Accept') { 'application/foo' }
    #         run_test!
    #       end
    #     end
    #   end
end
