class Api::V1::ToysController < ApplicationController
  def show
    @toy = Toy.find params[:id]
    render json: ToySerializer.new(@toy)
  end
end
