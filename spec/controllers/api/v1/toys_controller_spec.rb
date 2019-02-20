require 'rails_helper'

RSpec.describe Api::V1::ToysController, type: :controller do

  describe 'Get #show' do
    before :each do
      @toy = create :toy
      get :show, params: { id: @toy.id }
    end
    it { should respond_with 200 }
    it 'returns a toy response' do
      json_response = JSON.parse response.body, symbolize_names: true
      expect(json_response[:data][:attributes][:title]).to eq @toy.title
    end
  end

end
