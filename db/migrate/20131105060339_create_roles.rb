class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.integer :role_category_id

      t.timestamps
    end
  end
end
