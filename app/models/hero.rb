class Hero < ApplicationRecord
  has_many :hero_cases
  has_many :assigned_cases,
    class_name: Case.name,
    through: :hero_cases,
    source: :case
end
