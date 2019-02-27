class Toy < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  belongs_to :user

  scope :filter_by_title, -> (title) { where('title like ?', "%#{title}%") }
  scope :above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :below_or_equal_to_price, ->(price) { where('price <= ?', price) }
  scope :recent, -> { order('updated_at desc') }


  def self.search(params = {})
    toys = Toy.all
    toys = toys.filter_by_title(params[:title]) if params[:title].present?
    toys = toys.below_or_equal_to_price(params[:max_price]) if params[:max_price].present?
    toys = toys.above_or_equal_to_price(params[:min_price]) if params[:min_price].present?
    toys = toys.recent if params[:order] == 'desc'
    toys
  end
end
