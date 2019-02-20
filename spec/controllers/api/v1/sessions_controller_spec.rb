require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  # describe 'Post #create' do
  #   before :each do
  #     @user = create :user
  #   end
  #
  #   context 'when the credentials are correct' do
  #     before :each do
  #       credentials = { email: @user.email, password: '12345678' }
  #       post :create, params: { session: credentials }
  #     end
  #
  #     it { should response_with 200 }
  #
  #     it "returns the user record corresponding to the given credentials" do
  #       @user.reload
  #       expect(json_response[:auth_token]).to eq @user.auth_token
  #     end
  #   end
  #
  #   context 'when the credentials are incorrect' do
  #     before :each do
  #       credentials = { email: @user.email, password: 'qqqqqqqq' }
  #       post :create, params: { session: credentials }
  #     end
  #
  #     it { should response_with 422 }
  #
  #     it "returns a json with error" do
  #       expect(json_response[:errors]).to 'Invalid email or password'
  #     end
  #   end
  # end

end
