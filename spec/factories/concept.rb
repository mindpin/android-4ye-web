FactoryGirl.define do
  factory :concept do
    sequence(:name) {|n| "name_#{n}" }
    sequence(:desc){|n| "desc_#{n}" }
  end
end
