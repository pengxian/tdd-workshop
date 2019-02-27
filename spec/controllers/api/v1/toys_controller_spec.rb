require 'rails_helper'

RSpec.describe Api::V1::ToysController, type: :controller do

  describe 'Get #show' do
    before :each do
      @user = create :user
      @toy = create :toy, user: @user
      get :show, params: { id: @toy.id }
    end

    it { should respond_with 200 }

    it 'returns a toy response' do
      json_response = JSON.parse response.body, symbolize_names: true
      expect(json_response[:data][:attributes][:title]).to eq @toy.title
    end

    it 'returns user relationships in toy' do
      expect(json_response[:data][:relationships][:user][:data][:id].to_i).to eq @user.id
    end
  end

  describe 'Post #create' do
    context 'when create success' do
      before :each do
        @user = create :user
        api_authorization_header @user.auth_token
        @toy_attributes = attributes_for :toy
        post :create, params: { toy: @toy_attributes, user_id: @user.id }
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
        api_authorization_header @user.auth_token
        @invaild_toy_attributes = { title: nil, price: 10 }
        post :create, params: { toy: @invaild_toy_attributes, user_id: @user.id }
      end
      it { should respond_with 422 }
      it 'reader error json' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end

    describe 'PUT #update' do
      context 'when update success' do
        before :each do
          @user = create :user
          api_authorization_header @user.auth_token
          @toy = create :toy, user: @user
          @toy_attributes = { title: 'hahaha' }
          put :update, params: { toy: @toy_attributes, user_id: @user.id, id: @toy.id }
        end
        it { should respond_with 200 }
        it 'returns the user record' do
          json_response = JSON.parse response.body, symbolize_names: true
          expect(json_response[:data][:attributes][:title]).to eq @toy_attributes[:title]
        end
      end
      # TODO: when update fail
    end

    # TODO: delete #destroy

  end

end
