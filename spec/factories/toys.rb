FactoryBot.define do
  factory :toy do
    title { "MyString" }
    price { "9.99" }
    published { false }
    user
  end
end
