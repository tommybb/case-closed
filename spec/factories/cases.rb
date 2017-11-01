FactoryBot.define do
  factory :case do
    name 'Case name'
    sequence(:case_uid) { |i| "#{department_code}_#{i}" }
    officer_email 'john_doe@'
    officer_name 'John Doe'
    description 'Case description'
    department_code 'source_code'
    important false
  end
end
