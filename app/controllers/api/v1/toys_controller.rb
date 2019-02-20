class Api::V1::ToysController < ApplicationController
  def show
    @toy = Toy.find params[:id]
    render json: ToySerializer.new(@toy)
  end

  def create
    user = User.find(toy_params[:user_id])
    toy = user.toys.new(toy_params)
    if toy.save
      render json: ToySerializer.new(toy), status: 201
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  private

    def toy_params
      params.require(:toy).permit(:title, :price, :published, :user_id)
    end
end
