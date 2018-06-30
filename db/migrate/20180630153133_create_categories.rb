class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.integer :icon_id
      t.string :name
      t.integer :company_id
      t.timestamps
    end
  end
end
