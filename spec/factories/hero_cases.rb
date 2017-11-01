FactoryBot.define do
  factory :hero_case do
    case_id { create(:case).id }
    hero_id { create(:hero).id }
  end
end
