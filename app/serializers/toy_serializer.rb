class ToySerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :price, :published, :user_id

  belongs_to :user
end
