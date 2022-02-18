FactoryBot.define do
  factory :note do
    user { nil }
    title { "MyString" }
    note { "MyText" }
  end
end
