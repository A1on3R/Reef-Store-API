require 'rails_helper'


RSpec.describe "Stores", type: :request do


# let!(:stores) { create_list(:store,2) }
before(:all) do
  @stores = create_list(:store,2)
  get '/stores'
end


  describe "GET /stores" do
    
   
   it 'returns stores' do
    get '/stores'
    expect(json).not_to be_empty
    expect(json.size).to eq(2)
   end
   it 'returns status code 200' do
     expect(response).to have_http_status(200)
   end
    
  end

  describe 'POST /stores' do
    # valid payload
    let(:valid_name) { { name: 'XYZ' } }
    context 'when the request is valid' do
      before { post '/stores', params:{'store': valid_name } }
      it 'creates a store' do
        expect(json['name']).to eq('XYZ')
      end
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    context 'when the request is invalid' do
      before { post '/stores', params: {'store': { name: ''} } }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    #   it 'returns a validation failure message' do
    #     expect(response.body)
    #    .to include("is too short (minimum is 2 characters)")
    #   end
    end
  end
end
