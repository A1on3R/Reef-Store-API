FactoryBot.define do
  factory :item do
    name { "MyString" }
    price { 1.5 }
    description { "MyString" }
    store {Store.first || association(:store)}
  end
end
