class Api::V1::ToysController < ApplicationController
  def show
    toy = Toy.find params[:id]
    render json: ToySerializer.new(toy)
  end

  def create
    user = current_user
    toy = user.toys.new(toy_params)
    if toy.save
      render json: ToySerializer.new(toy), status: 201
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def update
    toy = current_user.toys.find_by(id: params[:id])
    return render json: { errors: 'params invalid' }, status: 422 if toy.blank?

    if toy.update_attributes toy_params
      render json: ToySerializer.new(toy), status: 200
    else
      render json: { errors: ErrorSerializer.new(toy).serialized_json }, status: 422
    end
  end

  def destroy
    toy = current_user.toys.find_by(id: params[:id])
    return render json: { errors: 'params invalid' }, status: 422 if toy.blank?
    toy.destroy
    head 204
  end

  private

    def toy_params
      params.require(:toy).permit(:title, :price, :published, :user_id)
    end
end
