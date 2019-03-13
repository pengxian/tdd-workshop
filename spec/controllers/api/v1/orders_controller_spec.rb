require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe 'Get #show' do
    before :each do
      @user = create :user
      @order = create :order, user: @user
      api_authorization_header @user.auth_token
      get :show, params: { id: @order.id, user_id: @user.id }
    end

    it { should respond_with 200 }

    it 'returns a order response' do
      expect(json_response[:data]).to be_present
    end
  end

  describe 'Get #index' do
    before :each do
      @user = create :user
      4.times { create :order, user: @user }
      api_authorization_header @user.auth_token
      get :index, params: { user_id: @user.id }
    end

    it { should respond_with 200 }

    it 'returns current user orders response' do
      expect(json_response[:data]).to be_present
    end

    it 'returns correct order number' do
      expect(json_response[:data].count).to eq 4
    end
  end

  describe 'Post #create' do
    context 'when create success' do
      before :each do
        @user = create :user
        @toy1 = create :toy
        @toy2 = create :toy
        api_authorization_header @user.auth_token
        post :create, params: { user_id: @user.id, order: { toy_ids: [@toy1.id, @toy2.id] } }
      end

      it { should respond_with 201 }

      it 'returns current user orders response' do
        expect(json_response[:data]).to be_present
      end

    end

  end

end
