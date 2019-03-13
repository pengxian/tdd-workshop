class Api::V1::OrdersController < ApplicationController
  def index
    orders = current_user.orders
    render json: OrderSerializer.new(orders)
  end

  def show
    order = current_user.orders.find params[:id]
    render json: OrderSerializer.new(order)
  end

  def create
    order = current_user.orders.build order_params
    if order.save
      render json: OrderSerializer.new(order), status: 201
    else
      render json: { errors: ErrorSerializer.new(order).serialized_json }, status: 422
    end
  end

  private
    def order_params
      params.require(:order).permit(toy_ids: [])
    end
end
