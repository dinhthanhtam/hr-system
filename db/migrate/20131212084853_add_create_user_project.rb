class AddCreateUserProject < ActiveRecord::Migration
  def change
    add_column :projects, :create_user_id, :integer
  end
end
