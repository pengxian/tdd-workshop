require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'Get #show' do
    before :each do
      @user = create :user
      get :show, params: { id: @user.id }
    end
    it { should respond_with 200 }
    it 'returns a user response' do
      json_response = JSON.parse response.body, symbolize_names: true
      expect(json_response[:data][:attributes][:email]).to eq @user.email
    end
  end

  describe 'Post #create' do
    context 'when create success' do
      before :each do
        @user_attributes = attributes_for :user
        post :create, params: { user: @user_attributes }
      end
      it { should respond_with 201 }
      it 'returns the user record' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:data][:attributes][:email]).to eq @user_attributes[:email]
      end
    end

    context 'when create fail' do
      before :each do
        @invaild_user_attributes = { password: '123456', password_confirmation: '123456' }
        post :create, params: { user: @invaild_user_attributes }
      end
      it { should respond_with 422 }
      it 'reader error json' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors].first[:detail]).to include("can't be blank")
      end
    end
  end

  describe 'Put #update' do

    context 'when update success' do
      before :each do
        @user = create :user
        @update_attributes = { email: 'test@domain.com' }
        put :update, params: { id: @user.id, user: @update_attributes }
      end
      it { should respond_with 200 }
      it 'returns the user record' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:data][:attributes][:email]).to eq @update_attributes[:email]
      end
    end

    context 'when invild parameter with id' do
      before :each do
        put :update, params: { id: 0 }
      end
      it { should respond_with 422 }
      it 'returns the errors of parameter error' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to eq 'invalid user id'
      end
    end

    context 'when invild parameter with password' do
      before :each do
        @user = create :user
        @invild_update_attributes = { password: '12345678', password_confirmation: '123456789' }
        put :update, params: { id: @user.id, user: @invild_update_attributes }
      end
      it { should respond_with 422 }
      it 'returns the errors of parameter error' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to eq 'invalid password'
      end
    end

    context 'when record not found' do
      before :each do
        @user = create :user
        @update_attributes = { email: 'test@domain.com' }
        put :update, params: { id: 999, user: @update_attributes }
      end
      it { should respond_with 404 }
      it 'returns the errors of record not found' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to eq 'record not found'
      end
    end

    context 'when update fail' do
      before :each do
        @user = create :user
        @invild_update_attributes = { email: nil }
        put :update, params: { id: @user.id, user: @invild_update_attributes }
      end
      it { should respond_with 422 }
      it 'returns the user record' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe 'Delete #destroy' do

    context 'when invild parameter with id' do
      before :each do
        delete :destroy, params: { id: 0 }
      end
      it { should respond_with 422 }
      it 'returns the errors of parameter error' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to eq 'invalid user id'
      end
    end

    context 'when destroy success' do
      before :each do
        @user = create :user
        delete :destroy, params: { id: @user.id }
      end
      it { should respond_with 204 }
      it 'returns result is true' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:result]).to eq true
      end
      it 'user will be not exist' do
        exist = User.exists?(id: @user.id)
        expect(exist).to eq false
      end
    end

    context 'when destroy record not found' do
      before :each do
        @user = create :user
        delete :destroy, params: { id: 999 }
      end
      it { should respond_with 404 }
      it 'returns record not found' do
        json_response = JSON.parse response.body, symbolize_names: true
        expect(json_response[:errors]).to eq 'record not found'
      end
      it 'user will be exist' do
        exist = User.exists?(id: @user.id)
        expect(exist).to eq true
      end
    end

  end

end
