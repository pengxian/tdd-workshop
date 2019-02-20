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

  describe 'Post #create' do
    context 'when create success' do
      before :each do
        @user = create :user
        @toy_attributes = attributes_for :toy
        @toy_attributes[:user_id] = @user.id
        post :create, params: { toy: @toy_attributes }
      end
      it { should respond_with 201 }
      it 'returns the user record' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:data][:attributes][:title]).to eq @toy_attributes[:title]
      end
    end

    context 'when create fail with title' do
      before :each do
        @user = create :user
        @invaild_toy_attributes = { title: nil, price: 10, user_id: @user.id }
        post :create, params: { toy: @invaild_toy_attributes }
      end
      it { should respond_with 422 }
      it 'reader error json' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end
  end

end
