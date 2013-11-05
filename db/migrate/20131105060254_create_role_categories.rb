class CreateRoleCategories < ActiveRecord::Migration
  def change
    create_table :role_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
