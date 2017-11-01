class Case < ApplicationRecord
  has_one :hero_case
  has_one :assigned_hero,
    class_name: Hero.name,
    through: :hero_case,
    source: :hero
end
