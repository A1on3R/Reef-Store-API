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
end
