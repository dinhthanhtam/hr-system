class AddNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :display_name, :string
    add_column :users, :team_id, :integer
    add_column :users, :cardID, :string
    add_column :users, :position, :string, default: "Staff"
  end
end
