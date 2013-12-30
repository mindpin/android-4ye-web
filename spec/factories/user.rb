FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name_#{n}" }
    sequence(:login){|n| "login_user_#{n}" }
    sequence(:email) {|n| "email_user_#{n}@163.com" }
    password '1234'
  end
end