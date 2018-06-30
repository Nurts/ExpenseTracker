class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :creator_id
      t.timestamps
    end

    create_table :companies_users, id: false do |t|
      t.belongs_to :user, index: true, unique: true
      t.belongs_to :company, index: true, unique: true
    end
  end
end
