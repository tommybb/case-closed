class CreateCases < ActiveRecord::Migration[5.1]
  def change
    create_table :cases do |t|
      t.string :name
      t.string :case_uid
      t.string :officer_email
      t.string :officer_name
      t.string :description
      t.string :department_code
      t.boolean :important

      t.timestamps
    end

    create_table :hero_cases do |t|
      t.integer :hero_id
      t.integer :case_id

      t.timestamps
    end
  end
end
