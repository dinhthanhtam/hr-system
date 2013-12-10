class CreateProjectUserRoles < ActiveRecord::Migration
  def change
    create_table :project_user_roles do |t|
      t.integer :project_user_id
      t.integer :project_role_id
      t.timestamps
    end
  end
end
