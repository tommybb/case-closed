FactoryBot.define do
  factory :hero do
    sequence(:name) { |i| "Hero ##{i}"}
  end
end
