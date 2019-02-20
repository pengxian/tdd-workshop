class Api::V1::UsersController < Api::V1::ApplicationController
  def show
    @user = User.find params[:id]
    render json: UserSerializer.new(@user)
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: 201
    else
      render json: { errors: ErrorSerializer.new(user).serialized_json }, status: 422
    end
  end

  def update
    return render json: { errors: 'invalid user id' }, status: 422 if params[:id].present? && params[:id].to_i == 0
    if user_params[:password].present? && user_params[:password_confirmation].present?
      return render json: { errors: 'invalid password' }, status: 422 if user_params[:password] != user_params[:password_confirmation]
    end
    user = User.find_by_id(params[:id])
    return render json: { errors: 'record not found' }, status: 404 unless user.present?
    if user.update(user_params)
      render json: UserSerializer.new(user), status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    return render json: { errors: 'invalid user id' }, status: 422 if params[:id].present? && params[:id].to_i == 0
    user = User.find_by_id(params[:id])
    return render json: { errors: 'record not found' }, status: 404 unless user.present?
    user.destroy
    render json: { result: true }, status: 204
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
